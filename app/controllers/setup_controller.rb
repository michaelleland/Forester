class SetupController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def jobs
  end
  
  def show_jobs
    
  end
  
  def ticket_ranges
    
    
    
    
  end
  
  def edit_range
    @range = TicketRange.find(params[:id])
    @range.from = params[:from]
    @range.to = params[:to]
    
    @all_ranges = TicketRange.all
    @all_ranges.delete_if {|i| i == @range}
    @overlapping_id = 0
    
    @all_ranges.each do |i|
      if i.from <= @range.to && @range.to <= i.to
        @overlapping_id = i.job_id
        break;
      end
      if i.from <= @range.from && @range.from <= i.to
        @overlapping_id = i.job_id
        break;
      end
    end
    
    if @overlapping_id == 0
      @range.save
      render :nothing => true
    else
      render :status => 306, :text => Job.find(@overlapping_id).name
    end
  end
  
  def new_range
    @job = Job.find(params[:id])
    
    if @job.ticket_ranges.create(:from => params[:from], :to => params[:to])
      render :text => @job.ticket_ranges.last.id
    else
      render :status => 500, :nothing => true
    end
  end
  
  def delete_range
    TicketRange.find(params[:id].to_i).delete
    render :nothing => true
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
    
    @content_type = 1
    render "new_whatever.js.erb"
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
  
    @content_type = 3
    render "new_whatever.js.erb"
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
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state] )
    @sawmill = Destination.create(:name => params[:sawmill_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
    
    @content_type = 4
    render "new_whatever.js.erb"
  end
    
  def edit_sawmill
    @sawmill = Destination.find(params[:sawmill_id])
     
    @contact_person = @sawmill.contact_person
    @address = @sawmill.address
    
    @contact_person.name = params[:cp_name]
    @contact_person.phone_number = params[:cp_phone]
    @contact_person.email = params[:cp_email]
    @contact_person.save
    
    @address.street = params[:address_street]
    @address.city = params[:address_city]
    @address.zip_code = params[:address_zip]
    @address.state = params[:address_state]
    @address.save
    
    @content_type = 4
    render "edit_whatever.js.erb"
  end
    
  def partners
    
  end
  
  def new_partner
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state])
    @partner = Partner.create(:name => params[:partner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
    
    @content_type = 2
    render "new_whatever.js.erb"
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
  
  def rates
    
  end

  def new_rate
    @destination = Destination.find_by_name(params[:destination_name])
    @job = Job.find(params[:id])
    
    if params[:type] == "logger"
      @logger_rate = LoggerRate.new(:destination_id => @destination.id, :partner_id => @job.logger.id, :job_id => @job.id, :rate_type => params[:rate_type], :rate => params[:rate])
      if @logger_rate.save
        render :text => "#{@logger_rate.id}"
      else
        render :status => 500
      end
    end
    if params[:type] == "trucker"
      @trucker_rate = TruckerRate.new(:destination_id => @destination.id, :partner_id => @job.trucker.id, :job_id => @job.id, :rate_type => params[:rate_type], :rate => params[:rate])
      if @trucker_rate.save
        render :text => "#{@trucker_rate.id}"
      else
        render :status => 500
      end
    end
  end
  
  def delete_rate
    if params[:type] == "logger"
      @logger_rate = LoggerRate.find(params[:id])
      if @logger_rate.delete
        render :nothing => true
      else
        render :state => 13
      end
    end
    if params[:type] == "trucker"
      @trucker_rate = TruckerRate.find(params[:id])
      if @trucker_rate.delete
        render :nothing => true
      else
        render :state => 13
      end
    end
  end
  
  def edit_rate
    if params[:type] == "logger"
      @logger_rate = LoggerRate.find(params[:id])
      @logger_rate.rate = params[:rate]
      @logger_rate.rate_type = params[:rate_type]
      if @logger_rate.save
        render :nothing => true
      else
        render :state => 13
      end
      
    end
    if params[:type] == "trucker"
      @trucker_rate = TruckerRate.find(params[:id]);
      @trucker_rate.rate = params[:rate]
      @trucker_rate.rate_type = params[:rate_type]
      if @trucker_rate.save
        render :nothing => true
      else
        render :state => 13
      end
      
    end
  end
  
end