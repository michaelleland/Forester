class Receipt < ActiveRecord::Base
  has_many :receipt_items
  has_and_belongs_to_many :tickets
  belongs_to :job
end
