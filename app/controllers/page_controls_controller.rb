class PageControlsController < ApplicationController
  layout nil
  
  #Ajax action
  #Renders the name of the job whiches ticket range includes the ticket number
  #If the given number is not in any of the ranges, error message is rendered.
  def get_job_name
    @ticket_num = params[:id].to_i
    Job.all.each do |i|
      i.ticket_ranges.each do |j|
        if j.from <= @ticket_num && @ticket_num <= j.to
          render :text => i.name
          return
        end
      end
    end
    render :text => "Invalid Ticket #"
  end
  
  #Ajax action
  #Renders a string formatted in the way of csv. It renders species codes, amounts in mbf and tonnage.
  #The format is: "CODE, CODE; MBF, MBF; TONS, TONS"
  def get_load_details
    @ticket = Ticket.find(params[:id])
    @species = ""
    @mbfs = ""
    @tons = ""
    
    @ticket.load_details.each do |i|
      if @species == ""
        if i.species_id == 0
          @species = "PU"
        else
          @species = "#{Specie.find(i.species_id).code}"
        end
      else
        if i.species_id == 0
          @species = "#{@species},PU}"
        else
          @species = "#{@species},#{Specie.find(i.species_id).code}"
        end
      end 
      
      if @mbfs == ""
        @mbfs = "#{i.mbfs}"
      else
        @mbfs = "#{@mbfs},#{i.mbfs}"
      end
      
      if @tons == ""
        @tons = "#{i.tonnnage}"
      else
        @tons = "#{@tons},#{i.tonnnage}"
      end
    end
    
    render :text => "#{@species};#{@mbfs};#{@tons}"
  end
  
  #Ajax action
  #Renders a html which contains 200 first ticket entries as table rows filled with ticket data
  def all_ticket_entries
   @ac = ApplicationController.new
   @tickets = Ticket.find(:all, :order => "created_at")[0..5000].reverse!
   @species = Specie.all
   @woodtypes = WoodType.all
  end
  
  #Same as above but for payment
  def all_payment_entries
    @ac = ApplicationController.new
    @payments = PaymentFromDestination.find(:all, :order => "created_at").reverse!
  end
  
  #Ajax action
  #Renders tickets not paid to given logger in given job as options (html element select's option elements) 
  def get_logger_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_logger(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  #Ajax action
  #Same as above, but for trucker
  def get_trucker_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_trucker(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  #Ajax action
  #Same as above, but for landowner
  def get_owner_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_owner(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  #Ajax action
  #Same as above, but for hfi
  def get_hfi_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_hfi(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  #Ajax action
  #Gets receipts according to given owner type and owner id
  def get_receipts
    @job = Job.find(params[:id])
    @receipts = []
    if params[:owner_type] == "owner"
      @receipts = Receipt.find_all_by_job_id_and_owner_id_and_owner_type(@job.id, @job.owner.id, "owner")
    end
    if params[:owner_type] == "logger"
      @receipts = Receipt.find_all_by_job_id_and_owner_id_and_owner_type(@job.id, @job.logger.id, "logger")
    end
    if params[:owner_type] == "trucker"
      @receipts = Receipt.find_all_by_job_id_and_owner_id_and_owner_type(@job.id, @job.trucker.id, "trucker")
    end
    if params[:owner_type] == "hfi"
      @receipts = Receipt.find_all_by_job_id_and_owner_id_and_owner_type(@job.id, 0, "hfi")
    end
  end
  
  #Ajax action
  #This action was used in ticket entry to open and close mbf and tonnage fields.
  #This feature is note in use anymore.
  def get_load_type
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find_by_name(params[:destination_name])
    
    @trucker_rate = TruckerRate.find_by_job_id_and_destination_id_and_partner_id(@job.id, @destination.id, @job.trucker.id)
    @logger_rate = LoggerRate.find_by_job_id_and_destination_id_and_partner_id(@job.id, @destination.id, @job.logger.id)
    
    @answer = ""
    
    if @trucker_rate.nil? && @logger_rate.nil?
      @answer = "No rates"
    end
    
    if @trucker_rate.nil? && !@logger_rate.nil?
      if @logger_rate.rate_type == "MBF"
        @answer = "MBF"
      else
        if @logger_rate.rate_type == "Tonnage"
          @answer == "Tonnage"
        end
      end
    end
    
    if !@trucker_rate.nil? && @logger_rate.nil?
      if @trucker_rate.rate_type == "MBF"
        @answer = "MBF"
      else
        if @trucker_rate.rate_type == "Tonnage"
          @answer == "Tonnage"
        end
      end
    end
    
    if !@trucker_rate.nil? && !@logger_rate.nil?
      if @trucker_rate.rate_type == "MBF" && @logger_rate.rate_type == "MBF"
        @answer = "MBF"
      else
        if @trucker_rate.rate_type == "Tonnage" && @logger_rate.rate_type == "Tonnage"
        @answer = "Tonnage"
        end
      end
      
      if @trucker_rate.rate_type == "MBF" && @logger_rate.rate_type == "Tonnage"
        @answer = "Both"
      else
        if @trucker_rate.rate_type == "Tonnage" && @logger_rate.rate_type == "MBF"
        @answer = "Both"
        end
      end
    end    
    render :text => @answer  
  end
  
  def get_the_inputs_to_ticket
    @ticket = Ticket.find(params[:id])
  end
  
  def get_the_inputs_to_payment
    @payment = PaymentFromDestination.find(params[:id])
  end
end
