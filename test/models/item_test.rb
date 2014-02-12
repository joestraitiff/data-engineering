require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "exercise validations" do
    i = Item.new
    assert i.invalid?

    assert i.errors[:description].present?
    i.description = '$20 off tasty burger'
    assert i.invalid?
    assert i.errors[:description].blank?

    assert i.errors[:price].present?
    i.price = 5.0
    assert i.invalid?
    assert i.errors[:price].blank?
    
    m = Merchant.new(name: 'Freds Burgers', address: 'portland, or')
    assert m.valid?
    
    assert i.errors[:merchant].present?
    i.merchant = m
    assert i.valid?
  end
end
