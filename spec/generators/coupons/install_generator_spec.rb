require 'spec_helper'

describe Coupons::InstallGenerator, type: 'generator' do
  destination './tmp'

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a test initializer' do
    expect(destination_root).to have_structure {
      directory 'config/initializers' do
        file 'coupons.rb'
      end
    }
  end
end
