class Item < ActiveRecord::Base
  belongs_to :merchant
  
  validates :description, :price, :merchant, presence: true
  validates :price, numericality: true
end
