class PageControlsController < ApplicationController
  layout nil
  
  
  def add_specie
    
  end
  
  def delete_specie
    
  end
  
  def import_jobs
    if params[:id] != "0"
      @jobs = Job.find_all_by_owner_id(params[:id]) 
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
    
  end
  
end
