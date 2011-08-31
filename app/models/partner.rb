class Partner < ActiveRecord::Base
  attr_accessor :rate_mbf, :rate_tonnage, :rate_percent
  
  def rate_tonnage(job_id)
    @rate_tonnage = TruckerRate.find_by_job_id_and_partner_id(job_id, self.id).rate_tonnage
  end
  
  def rate_percent(job_id)
    @rate_percent = @rate_tonnage = TruckerRate.find_by_job_id_and_partner_id(job_id, self.id).rate_percent
  end
  
  def rate_mbf(job_id)
    @rate_mbf = @rate_tonnage = TruckerRate.find_by_job_id_and_partner_id(job_id, self.id).rate_mbf
  end
end
