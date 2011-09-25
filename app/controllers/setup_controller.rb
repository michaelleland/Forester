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
  
  def new_job
    @owner = Owner.find_by_name(params[:owner_name])
    @logger = Partner.find_by_name(params[:logger_name])
    @trucker = Partner.find_by_name(params[:trucker_name])
    
    @job = Job.create(:name => params[:job_name], :owner_id => @owner.id, :hfi_rate => params[:hfi_rate], :hfi_prime => params[:hfi_prime])
    LoggerAssignment.create(:job_id => @job.id, :partner_id => @trucker.id, :pays_to_trucker => false)
    TruckerAssignment.create(:job_id => @job.id, :partner_id => @trucker.id)
  end
  
  def edit_job
    @job = Job.find(params[:job_id])
    
    @old_owner = @job.owner
    @old_logger = @job.logger
    @old_trucker = @job.trucker
    
    @owner = Owner.find_by_name(params[:owner_name])
    @logger = Partner.find_by_name(params[:logger_name])
    @trucker = Partner.find_by_name(params[:trucker_name])
    
    @job.name = params[:job_name]
    @job.owner_id = @owner.id
    @job.hfi_rate = params[:hfi_rate]
    @job.hfi_prime = params[:hfi_prime]
    @job.save
    
    @la = LoggerAssignment.find_by_job_id_and_partner_id(@job.id, @old_logger.id)
    @la.partner_id = @logger.id
    @la.save
    
    @ta = TruckerAssignment.find_by_job_id_and_partner_id(@job.id, @old_trucker.id)
    @ta.partner_id = @trucker.id
    @ta.save
    
    @content_type = 1
    render "edit_whatever.js.erb"
  end
  
  def new_owner
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state])
    @owner = Owner.create(:name => params[:owner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
  end
  
  def edit_owner
    @owner = Owner.find(params[:owner_id])
    
    @contact_person = @owner.contact_person
    @address = @owner.address
    
    @contact_person.name = params[:cp_name]
    @contact_person.phone_number = params[:cp_phone]
    @contact_person.email = params[:cp_email]
    @contact_person.save
    
    @address.street = params[:address_street]
    @address.city = params[:address_city]
    @address.zip_code = params[:address_zip]
    @address.state = params[:address_state]
    @address.save
    
    @content_type = 3
    render "edit_whatever.js.erb"
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
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state])
    @partner = Partner.create(:name => params[:partner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
  end
  
  def edit_partner
    @partner = Partner.find(params[:partner_id])
    @partner.name = params[:partner_name]
    @partner.save
    
    @contact_person = @partner.contact_person
    @address = @partner.address
    
    @contact_person.name = params[:cp_name]
    @contact_person.phone_number = params[:cp_phone]
    @contact_person.email = params[:cp_email]
    @contact_person.save
    
    @address.street = params[:address_street]
    @address.city = params[:address_city]
    @address.zip_code = params[:address_zip]
    @address.state = params[:address_state]
    @address.save
    
    @content_type = 2
    render "edit_whatever.js.erb"
  end
end
