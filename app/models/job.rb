class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  
end
