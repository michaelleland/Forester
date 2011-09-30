class PaymentFromDestination < ActiveRecord::Base
  
  def destination
    @destination = Destination.find(self.destination_id)
  end
  
  def job
    @job = Job.find(self.job_id)
  end
  
end
