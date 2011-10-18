class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  
  attr_accessor :owner_value, :logger_value, :trucker_value, :hfi_value
  
  def net_mbf
    @net_mbf = 0
    unless self.wood_type == 3
      self.load_details.each do |i|
        unless i.mbfs.nil?
          @net_mbf = @net_mbf + i.mbfs
        end
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
        unless i.tonnage.nil?
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
  
  def load_type
    @load_type = self.load_details.first.load_type
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
  
  def trucker_rate
    @trucker_rate = TruckerRate.find_by_destination_id_and_job_id_and_partner_id(self.destination_id, self.job_id, Job.find(self.job_id).trucker.id)
  end
  
  def logger_rate
    @logger_rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(self.destination_id, self.job_id, Job.find(self.job_id).logger.id)
  end
  
end
