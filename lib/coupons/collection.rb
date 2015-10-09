module Coupons
  class Collection < SimpleDelegator
    def any?
      to_ary.any?
    end

    def to_ary
      @to_ary ||= super
    end
  end
end
