class Partner < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact_person
  
  def hauling_rate(job_id, destination_id)
    @hauling_rate = TruckerRate.find_by_job_id_and_destination_id_and_partner_id(job_id, destination_id, self.id).rate
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
