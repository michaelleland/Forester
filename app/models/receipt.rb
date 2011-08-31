class Receipt < ActiveRecord::Base
  has_many :receipt_items
  
  belongs_to :job
end
