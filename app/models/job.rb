class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  
  attr_accessor :logger
  
  def logger
    @logger = Partner.find(LoggerAssignment.find_by_job_id(self.id).partner_id)
  end
  
end
