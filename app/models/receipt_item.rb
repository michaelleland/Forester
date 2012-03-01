class ReceiptItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :job
  
  #Receipt items are save deductions of a receipt
end
