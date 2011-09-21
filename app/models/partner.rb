class Partner < ActiveRecord::Base
  
  attr_accessor :rate_mbf, :rate_tonnage, :rate_percent, :hauling_rate, :contact_person, :address
  
  def hauling_rate(job_id, destination_id)
    @hauling_rate = TruckerRates.find_by_job_id_and_destination_id_and_partner_id(job_id, destination_id, self.id).rate
  end
  
  def hauling_rate_tonnage(job_id, destination_id)
    @hauling_rate = TruckerRates.find_by_job_id_and_destination_id_and_partner_id(job_id, destination_id, self.id).rate
  end
  
  def logging_rate(destination_id, job_id)
    @logging_rate = LoggerRate.find_by_job_id_and_destination_id_and_partner_id(job_id, destination_id, self.id).rate
  end 
  
  def address
    @address = Address.find(self.address_id)
  end
  
  def contact_person
    @contact_person = ContactPerson.find(self.contact_person_id)
  end
end
