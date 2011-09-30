class Receipt < ActiveRecord::Base
  has_many :receipt_items
  has_and_belongs_to_many :tickets
  belongs_to :job
  
  def job
    @job = Job.find(self.job_id)
  end
  
end
