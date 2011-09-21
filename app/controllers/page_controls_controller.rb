class PageControlsController < ApplicationController
  layout nil
  
  def all_ticket_entries
   @tickets = Ticket.all 
  end
  
  def all_payment_entries
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
