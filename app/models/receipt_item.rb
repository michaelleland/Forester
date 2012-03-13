class ReceiptItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :job

  validates :job_id, :presence => true
  validates :owner_type, :presence => true
  
  #Receipt items are saved deductions of a receipt
end
