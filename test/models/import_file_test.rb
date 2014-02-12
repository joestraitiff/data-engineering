require 'test_helper'

class ImportFileTest < ActiveSupport::TestCase
  test "invalid won't import" do
    imp = ImportFile.new
    assert !imp.import
  end
  
  test "import valid file" do
    file = Rack::Test::UploadedFile.new('test/samples/example_input.tab', 'text/plain')
    imp = ImportFile.new(file: file)
    
    assert imp.valid?
    
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count'], 3) do
      assert_difference('Purchase.count', 4) do
        assert imp.import
      end
    end
    
    # assert that duplicates were rejected
    assert_equal 1, Customer.where(name: "Snake Plissken").count
    assert_equal 1, Item.where(description: "$20 Sneakers for $5").count
    assert_equal 1, Merchant.where(name: "Sneaker Store Emporium").count
  end

  test "import invalid file" do
    file = Rack::Test::UploadedFile.new('test/samples/bad_input.tab', 'text/plain')
    imp = ImportFile.new(file: file)
    
    assert imp.valid?
    
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count', 'Purchase.count'], 0) do
      assert imp.import
    end
    
    
  end
  
end
