require 'test_helper'

class ImportFilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
  end
  
  test "should error with empty file" do
    post :create, import_file: { file: nil }
    assert_response :success
    assert_template :new
    
    import_file = assigns(:import_file)
    assert import_file
    assert import_file.errors.count > 0
  end

  test "should successfully import good file" do
    file = Rack::Test::UploadedFile.new('test/samples/example_input.tab', 'text/plain')
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count'], 3) do
      assert_difference('Purchase.count', 4) do
        post :create, import_file: { file: file }
      end
    end
    
    import_file = assigns(:import_file)
    assert import_file

    results = import_file.results
    assert_equal 0, results[:error_rows].size
    assert_equal 4, results[:successful_rows]
    assert_equal 95.0, results[:revenue].to_f

    assert flash[:results].present?

    assert_redirected_to import_files_path
  end

  test "should show errors on bad import file" do
    file = Rack::Test::UploadedFile.new('test/samples/bad_input.tab', 'text/plain')
    assert_difference(['Customer.count', 'Merchant.count', 'Item.count', 'Purchase.count'], 0) do
      post :create, import_file: { file: file }
    end

    import_file = assigns(:import_file)
    assert import_file

    results = import_file.results
    assert_equal 6, results[:error_rows].size
    assert_equal 0, results[:successful_rows]
    assert_equal 0, results[:revenue].to_f
    
    assert flash[:results].present?

    assert_redirected_to import_files_path
  end
end
