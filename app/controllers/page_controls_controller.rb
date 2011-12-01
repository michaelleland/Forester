class PageControlsController < ApplicationController
  layout nil
  
  def get_job
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
  
  def all_ticket_entries
   @ac = ApplicationController.new
   @tickets = Ticket.all[0..200] 
   @species = Specie.all
   @woodtypes = WoodType.all
  end
  
  def all_payment_entries
    @ac = ApplicationController.new
    @payments = PaymentFromDestination.all
  end
  
  def get_payments
    @unpaid_payments = PaymentFromDestination.find_all_by_job_id_and_paid_to_owner(params[:id], false, :order => "payment_date")
  end
  
  def get_logger_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_logger(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  def get_trucker_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_trucker(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  def get_owner_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_owner(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
  def get_hfi_tickets
    @tickets = Ticket.find_all_by_job_id_and_paid_to_hfi(params[:id], false, :order => "number")
    render "get_tickets.html.erb"
  end
  
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
  end
  
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
  
  def add_specie
    
  end
  
  def delete_specie
    
  end
  
  def import_jobs_of_partner
    if params[:id] != "0"
      @l_asg = LoggerAssignment.find_all_by_partner_id(params[:id])
      
      @l_job_ids = @l_asg.collect {|i| i.job_id}.flatten
      
      @logger_jobs = Job.find(@l_job_ids)
      
      @t_asg = TruckerAssignment.find_all_by_partner_id(params[:id])
      
      @t_job_ids = @t_asg.collect {|i| i.job_id}.flatten
      
      @trucker_jobs = Job.find(@t_job_ids)
      
      @jobs = @trucker_jobs + @logger_jobs
      @jobs.flatten!
      @jobs.uniq!
      @jobs = @jobs.sort_by {|i| i.name } 
    end
  end
  
  def import_jobs_of_logger
    if params[:id] != "0"
      @l_asg = LoggerAssignment.find_all_by_partner_id(params[:id])
      
      @l_job_ids = @l_asg.collect {|i| i.job_id}.flatten
      
      @logger_jobs = Job.find(@l_job_ids)
    end
  end
  
  def import_jobs_of_trucker
    if params[:id] != "0"
      @t_asg = TruckerAssignment.find_all_by_partner_id(params[:id])
      
      @t_job_ids = @t_asg.collect {|i| i.job_id}.flatten
      
      @trucker_jobs = Job.find(@t_job_ids)
    end
  end
  
  def import_jobs_of_owner
    if params[:id] != "0"
      @owner_jobs = Job.find_all_by_owner_id(params[:id])
    end
  end
  
end
