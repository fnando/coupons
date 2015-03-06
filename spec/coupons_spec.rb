require 'spec_helper'

describe Coupons do
  context 'default configuration' do
    before do
      load File.expand_path('../../lib/coupons.rb', __FILE__)
    end

    it 'sets configuration' do
      expect(Coupons.configuration).to be_a(Coupons::Configuration)
    end
  end
end
