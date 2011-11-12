class PaymentFromDestination < ActiveRecord::Base
  
  def destination
    @destination = Destination.find(self.destination_id)
  end
  
  def job
    @job = Job.find(self.job_id)
  end
  
  def tonnnage
    unless self.tonnage.nil?
      self.tonnage
    else
      0
    end
    
  end
  
  def net_mbff
    if self.net_mbf.nil?
      0
    else
      self.net_mbf
    end
  end
  
  
end
