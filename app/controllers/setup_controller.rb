class SetupController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def jobs
  end
  
  def show_jobs
    
  end
  
  def owners
    
  end
  
  def new_owner
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip])
    @owner = Owner.create(:name => params[:owner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
  end

  def sawmills
    
  end
  
  def new_sawmill
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip])
    @sawmill = Destination.create(:name => params[:sawmill_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
  end
    
  def rates
    
  end

  def new_rate
    @destination = Destination.find_by_name(params[:destination_name])
    @job = Job.find(params[:id])
    
    if params[:type] == "logger"
      @logger_rate = LoggerRate.create(:destination_id => @destination.id, :partner_id => @job.logger.id, :job_id => @job.id, :rate_type => params[:rate_type], :rate => params[:rate])
    end
    if params[:type] == "trucker"
      @trucker_rate = TruckerRate.create(:destination_id => @destination.id, :partner_id => @job.trucker.id, :job_id => @job.id, :rate_type => params[:rate_type], :rate => params[:rate])
    end
  end
  
  def partners
    
  end
  
  def new_partner
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip])
    @partner = Partner.create(:name => params[:partner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
  end
end
