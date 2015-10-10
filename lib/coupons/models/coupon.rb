module Coupons
  module Models
    class Coupon < ActiveRecord::Base
      # Allow using `type` as a column.
      self.inheritance_column = nil

      # Set table name.
      self.table_name = :coupons

      # Set default values.
      after_initialize do
        self.code ||= Coupons.configuration.generator.call
        self.valid_from ||= Date.current

        attachments_will_change!
        write_attribute :attachments, {} if attachments.empty?
      end

      has_many :redemptions, class_name: 'Coupons::Models::CouponRedemption'

      validates_presence_of :code, :valid_from
      validates_inclusion_of :type, in: %w[percentage amount]

      serialize :attachments, GlobalidSerializer

      validates_numericality_of :amount,
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 100,
        only_integer: true,
        if: :percentage_based?

      validates_numericality_of :amount,
        greater_than_or_equal_to: 0,
        only_integer: true,
        if: :amount_based?

      validates_numericality_of :redemption_limit,
        greater_than_or_equal_to: 0

      validate :validate_dates

      def apply(options)
        input_amount = BigDecimal("#{options[:amount]}")
        discount = BigDecimal(percentage_based? ? percentage_discount(options[:amount]) : amount)
        total = [0, input_amount - discount].max

        options = options.merge(total: total, discount: discount)

        options = Coupons.configuration.resolvers.reduce(options) do |options, resolver|
          resolver.resolve(self, options)
        end

        options
      end

      def redemptions_count
        coupon_redemptions_count
      end

      def expired?
        valid_until && valid_until <= Date.current
      end

      def has_available_redemptions?
        redemptions_count.zero? || redemptions_count < redemption_limit
      end

      def started?
        valid_from <= Date.current
      end

      def redeemable?
        !expired? && has_available_redemptions? && started?
      end

      def to_partial_path
        'coupons/coupon'
      end

      def percentage_based?
        type == 'percentage'
      end

      def amount_based?
        type == 'amount'
      end

      private

      def percentage_discount(input_amount)
        BigDecimal("#{input_amount}") * (BigDecimal("#{amount}") / 100)
      end

      def validate_dates
        if valid_until_before_type_cast.present?
          errors.add(:valid_until, :invalid) unless valid_until.kind_of?(Date)
          errors.add(:valid_until, :coupon_already_expired) if valid_until? && valid_until < Date.current
        end

        if valid_from.present? && valid_until.present?
          errors.add(:valid_until, :coupon_valid_until) if valid_until < valid_from
        end
      end
    end
  end
end
