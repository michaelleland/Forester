class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  has_many :ticket_ranges
  
  def logger
    @asg = LoggerAssignment.find_by_job_id(self.id)
    @logger = Partner.find(@asg.partner_id)
  end
  
  def trucker
    @asg = TruckerAssignment.find_by_job_id(self.id)
    @trucker = Partner.find(@asg.partner_id)
  end
  
  def owner
    @owner = Owner.find_by_id(self.owner_id)
  end
  
  def trucker_rates_details
    @trucker_rates = TruckerRate.find_all_by_job_id_and_partner_id(self.id, self.trucker.id)
  end
  
  def logger_rates_details
    @logger_details = LoggerRate.find_all_by_job_id_and_partner_id(self.id, self.logger.id)
  end
  
end
