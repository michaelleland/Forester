class ReceiptItem < ActiveRecord::Base
  belongs_to :receipt
  
  #Receipt items are save deductions of a receipt
end
