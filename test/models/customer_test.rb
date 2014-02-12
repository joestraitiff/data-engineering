require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "exercise validations" do
    c = Customer.new
    assert c.invalid?
    assert c.errors[:name].present?
    c.name = 'test guy'
    assert c.valid?
  end
end
