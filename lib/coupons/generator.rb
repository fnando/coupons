require 'securerandom'

module Coupons
  class Generator
    attr_reader :options

    def initialize(options = {})
      @options = {}
    end

    def call
      size = options.fetch(:size, 6)
      SecureRandom.hex(size)[0, size].upcase
    end
  end
end
