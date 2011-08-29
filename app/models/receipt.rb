class Receipt < ActiveRecord::Base
  has_many :receipt_items
  belongs_to :job
  
  def job
    @job = Job.find(self.job_id)
  end
  
end
