class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  
  attr_accessor :owner_value, :logger_value, :trucker_value, :hfi_value
  
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
  
  def net_mbf
    @net_mbf = 0
    unless self.wood_type == 3
      self.load_details.each do |i|
        @net_mbf = @net_mbf + i.mbfs
      end
    else
      return nil
    end
    @net_mbf
  end
  
  def tonnage
    unless self.wood_type == 3
      @total = 0
      self.load_details.each do |i|
        if i.load_type == "Tonnage"
          @total = @total + i.tonnage
        end
      end
      if @total == 0
        return nil
      else
        @total
      end
    else
      @tonnage = self.load_details.first.tonnage
    end
  end
  
  def job
    @job = Job.find(self.job_id)
  end
  
  def destination
    @destination = Destination.find(self.destination_id)
  end
  
  def load_details
    @load_details = LoadDetail.find_all_by_ticket_id(self.id) 
  end
  
end
