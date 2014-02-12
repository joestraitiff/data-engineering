class Merchant < ActiveRecord::Base
  validates :name, :address, presence: true
end
