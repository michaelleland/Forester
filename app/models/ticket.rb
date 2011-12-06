class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  belongs_to :destination
  
  attr_accessor :owner_value, :logger_value, :trucker_value, :hfi_value
  
  #Both net mbf and net tonnage do basically the same
  #All of the load details of a ticket are gathered and their mbf/tonnage
  #values are added up.
  def net_mbf
    @net_mbf = 0
    unless self.wood_type == 3
      self.load_details.each do |i|
        unless i.mbfs.nil?
          @net_mbf = @net_mbf + i.mbfs
        end
      end
    else
      return 0
    end
    @net_mbf
  end
  
  #See description above
  def tonnage
    unless self.wood_type == 3 #If the wood type is pulp, then there will be only one load detail
      @total = 0
      self.load_details.each do |i|
        unless i.tonnage.nil?
          @total = @total + i.tonnage
        end
      end
      if @total == 0
        return 0
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
  
  #Return all load details associated with the ticket
  def load_details
    @load_details = LoadDetail.find_all_by_ticket_id(self.id) 
  end
  
  #These methods return trucker and logger rates for the tickets
  def trucker_rate
    @trucker_rate = TruckerRate.find_by_destination_id_and_job_id_and_partner_id(self.destination_id, self.job_id, Job.find(self.job_id).trucker.id)
  end
  
  def logger_rate
    @logger_rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(self.destination_id, self.job_id, Job.find(self.job_id).logger.id)
  end
  
end
