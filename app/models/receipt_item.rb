class ReceiptItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :job
  
  #Receipt items are saved deductions of a receipt
end
