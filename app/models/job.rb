class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  has_one :owner
  
  attr_accessor :logger
  
  def logger
    @asg = LoggerAssignment.find_by_job_id(self.id)
    @logger = Partner.find(@asg.partner_id)
  end
  
end
