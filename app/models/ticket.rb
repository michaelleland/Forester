class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  
  #def logger_value
  #  @logger = Job.find(self.job_id).logger
  #  @asg = LoggerAssignment.find_by_job_id(self.job_id)
  #  
  #  unless @asg.rate_mbf.nil? && self.load_details.first.load_type == "MBF"
  #    @logger_value = @asg.rate_mbf * self.load_details.
  #  end
  #end
  
  #def trucker_value
    
  #end
  
  #def hfi_value
    
  #end
  
  #def owner_value
  #  self.value - self.trucker_value - self.logger_value - self.hfi_value
  #end
  
  def load_details
    @load_details = LoadDetail.find_all_by_ticket_id(self.id) 
  end
  
end
