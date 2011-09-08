class Partner < ActiveRecord::Base
  has_one :contact_person
  has_one :address
  
  attr_accessor :rate_mbf, :rate_tonnage, :rate_percent, :hauling_rate
  
  def hauling_rate(job_id, destination_id)
    @hauling_rate = TruckerRates.find_by_job_id_and_destination_id_and_partner_id(job_id, destination_id, self.id).rate
  end
  
  def rate_tonnage(job_id)
    @rate_tonnage = LoggerAssignment.find_by_job_id_and_partner_id(job_id, self.id).rate_tonnage
  end
  
  def rate_percent(job_id)
    @rate_percent = @rate_tonnage = LoggerAssignment.find_by_job_id_and_partner_id(job_id, self.id).rate_percent
  end
  
  def rate_mbf(job_id)
    @rate_mbf = @rate_tonnage = LoggerAssignment.find_by_job_id_and_partner_id(job_id, self.id).rate_mbf
  end
end
