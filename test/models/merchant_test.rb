require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  test "exercise validations" do
    m = Merchant.new
    assert m.invalid?

    assert m.errors[:name].present?
    m.name = 'cool merchant'
    assert m.invalid?
    assert m.errors[:name].blank?
    
    assert m.errors[:address].present?
    m.address = 'somwhere'
    assert m.valid?
  end
end
