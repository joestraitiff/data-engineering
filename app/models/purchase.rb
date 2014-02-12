class Purchase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :item
  
  validates :item, :customer, :count, presence: true
  validates :count, numericality: true
end
