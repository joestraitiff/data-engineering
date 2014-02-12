require 'csv'

class ImportFile
  include ActiveModel::Model

  attr_accessor :file
  attr_reader :processed_rows
  
  validates :file, presence: true
  
  def import
    return false if invalid?
    reset_stats
    
    begin
      CSV.foreach(file.tempfile, headers: true, col_sep: "\t") do |row|
        @processed_rows += 1
        add_row_to_database(row)
      end
      true
    rescue Exception => e
      errors.add(:file, e.message)
      false 
    end
  end
  
  def filename
    file.original_filename
  end
  
  def results
    {
      file: file.original_filename,
      revenue: @total_revenue,
      successful_rows: @successful_rows,
      error_rows: @error_rows,
      processed_rows: @processed_rows
    }
  end
  
private

  def reset_stats
    @processed_rows = 0
    @total_revenue = 0
    @successful_rows = 0
    @error_rows = []
  end

  def add_row_to_database(row)
    Rails.logger.debug row.inspect
    
    ActiveRecord::Base.transaction do
      current_object = 'Customer'
      begin
        customer = Customer.find_or_create_by!(name: row['purchaser name'])
        current_object = 'Merchant'
        merchant = Merchant.find_or_create_by!(name: row['merchant name'], address: row['merchant address'])
        current_object = 'Item'
        item = Item.find_or_create_by!(description: row['item description'], price: row['item price'], merchant: merchant)
        current_object = 'Purchase'
        purchase = Purchase.create!(customer: customer, item: item, count: row['purchase count'])
        
        @successful_rows += 1
        @total_revenue += (purchase.count * item.price)
      rescue Exception => e
        error_msg = "#{current_object}: #{e.message}"
        @error_rows << {row: @processed_rows, error: error_msg}
        raise ActiveRecord::Rollback, "Row #{@processed_rows} error #{error_msg}"
      end
    end
  end
  
end
