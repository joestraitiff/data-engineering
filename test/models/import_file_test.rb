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
    assert_equal 'example_input.tab', imp.filename
    
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count'], 3) do
      assert_difference('Purchase.count', 4) do
        assert imp.import
      end
    end
    
    # assert that duplicates were rejected
    assert_equal 1, Customer.where(name: "Snake Plissken").count
    assert_equal 1, Item.where(description: "$20 Sneakers for $5").count
    assert_equal 1, Merchant.where(name: "Sneaker Store Emporium").count

    expected_results(imp.results, processed_rows: 4, revenue: 95.0, successful_rows: 4, error_rows: [])
  end

  test "import invalid file" do
    file = Rack::Test::UploadedFile.new('test/samples/bad_input.tab', 'text/plain')
    imp = ImportFile.new(file: file)
    
    assert imp.valid?
    assert_equal 'bad_input.tab', imp.filename
    
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count', 'Purchase.count'], 0) do
      assert imp.import
    end
    
    results = imp.results
    expected_results(results, processed_rows: 6, revenue: 0, successful_rows: 0)
    assert_equal 6, results[:error_rows].size
  end
  
  def expected_results(results, expected)
    expected.keys.each do |k|
      assert_equal expected[k], results[k]
    end
  end
  
end
