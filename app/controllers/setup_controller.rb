class SetupController < ApplicationController
  layout nil
  
  #Show action
  def index
    
  end
  
  #Show action
  def jobs
  
  end
  
  #Show action
  def show_jobs
    
  end
  
  #Show action
  def ticket_ranges
    
  end
  
  #Ajax action
  #Sets the boundaries of a given range into given values, if they are not overlapping with some other job's
  # ticket range. In that case, "error" status 306 is rendered with the name of the job which has
  # overlapping range.
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
      if i.to <= @range.to && i.from >= @range.from
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
  
  #Ajax action
  #Creates a new range with given boundaries if it does not overlap with any existing range's boundaries.
  #In the latter case, the name of the job with overlapping range is rendered
  def new_range
    @job = Job.find(params[:id])
    @range = TicketRange.new(:from => params[:from], :to => params[:to])
    
    @all_ranges = TicketRange.all
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
      if i.to <= @range.to && i.from >= @range.from
        @overlapping_id = i.job_id
        break;
      end
    end
    
    if @overlapping_id == 0
      @range.save
      @job.ticket_ranges.push(@range)
      render :text => @job.ticket_ranges.last.id
    else
      render :status => 306, :text => Job.find(@overlapping_id).name
    end
  end
  
  def delete_range
    TicketRange.find(params[:id].to_i).delete
    render :nothing => true
  end
  
  def owners
    
  end
  
  #Ajax action
  #Creates a new job with given data.
  #Renders a javascript which fires a function from application.js with parameters
  # depending on the value of @content type. This function reloads the accordion on the page.
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
  
  #Ajax action
  #Edits the job, as simple as that.
  #Rendering done in the same way as above.
  def edit_job
    job = Job.find(params[:job_id])
    
    old_owner = job.owner
    old_logger = job.logger
    old_trucker = job.trucker
    
    owner = Owner.find_by_name(params[:owner_name])
    logger = Partner.find_by_name(params[:logger_name])
    trucker = Partner.find_by_name(params[:trucker_name])
    
    job.name = params[:job_name]
    job.owner_id = owner.id
    job.hfi_rate = params[:hfi_rate]
    job.hfi_prime = params[:hfi_prime]
    job.save
    
    la = LoggerAssignment.find_by_job_id_and_partner_id(job.id, old_logger.id)
    la.partner_id = logger.id
    la.save
    
    ta = TruckerAssignment.find_by_job_id_and_partner_id(job.id, old_trucker.id)
    ta.partner_id = trucker.id
    ta.save
    
    @content_type = 1
    render "edit_whatever.js.erb"
  end
  
  #Ajax action
  #Creates a new landowner
  #About rendering: see comments above.
  def new_owner
    contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state])
    owner = Owner.create(:name => params[:owner_name], :address_id => address.id, :contact_person_id => contact_person.id)
    
    @content_type = 3
    render "new_whatever.js.erb"
  end
  
  #Ajax action
  #Edits a landowner
  #About rendering: see comments above.
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
  
  #Ajax action
  #Creates a new sawmill
  #About rendering: see comments above.
  def new_sawmill
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state] )
    @sawmill = Destination.create(:name => params[:sawmill_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
    
    @content_type = 4
    render "new_whatever.js.erb"
  end
  
  #Ajax action
  #Edits a sawmill
  #About rendering: see comments above.
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
  
  #Ajax action
  #Creates a new partner (logger/trucker)
  #About rendering: see comments above.
  def new_partner
    @contact_person = ContactPerson.create(:name => params[:cp_name], :phone_number => params[:cp_phone], :email => params[:cp_email])
    @address = Address.create(:street => params[:address_street], :city => params[:address_city], :zip_code => params[:address_zip], :state => params[:address_state])
    @partner = Partner.create(:name => params[:partner_name], :address_id => @address.id, :contact_person_id => @contact_person.id)
    
    @content_type = 2
    render "new_whatever.js.erb"
  end
  
  #Ajax action
  #Edits a partner
  #About rendering: see comments above.
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
  
  #Show view action
  def rates
    
  end

  #Ajax action
  #Creates a new Rate record for a logger/trucker (depending on given type) to a destination.
  def new_rate
    @destination = Destination.find(params[:destination_id])
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
        render :text => "#{@trucker_rate.id},#{@destination.id}"
      else
        render :status => 500
      end
    end
  end
  
  #Ajax action
  #Deletes a rate from db
  def delete_rate
    if params[:type] == "logger"
      @logger_rate = LoggerRate.find(params[:id])
      if @logger_rate.delete
        render :nothing => true
      else
        render :state => 13 #I'm not sure why in case of failior state 13 is rendered. Just for fun? :S
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
  
  #Ajax action
  #Edits a rate of given type.
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
  
  #Ajax action
  #This method is used in rate's accordion view, to make sure that to one destination only one rate exists
  #It renders the ids of existing rates destinations as a csv string.
  def get_existing
    
    rates_string = ""
    
    if params[:type] == "logger"
      logger_rates = LoggerRate.find_all_by_job_id_and_partner_id(params[:id], params[:partner_id])
      
      rates_string << "#{logger_rates.first.destination_id}"
      logger_rates.delete(logger_rates.first)
      
      logger_rates.each do |i|
        rates_string << ",#{i.destination_id}"
      end
    end
    
    if params[:type] == "trucker"
      trucker_rates = TruckerRate.find_all_by_job_id_and_partner_id(params[:id], params[:partner_id])
      
      rates_string << "#{trucker_rates.first.destination_id}"
      trucker_rates.delete(trucker_rates.first)
      
      trucker_rates.each do |i|
        rates_string << ",#{i.destination_id}"
      end
    end
    render :text => rates_string
  end
  
end