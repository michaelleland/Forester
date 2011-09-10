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
  
  def import_jobs_of_partner
    if params[:id] != "0"
      @t_asg = TruckerAssignment.find_all_by_partner_id(params[:id])
      @l_asg = LoggerAssignment.find_all_by_partner_id(params[:id])
      
      @t_job_ids = @t_asg.collect {|i| i.job_id}.flatten
      @l_job_ids = @l_asg.collect {|i| i.job_id}.flatten
      
      @t_job_ids.each do |i|
        @trucker_jobs.push(Job.find(i))
      end
      
      @l_job_ids.each do |i|
        @logger_jobs.push(Job.find(i))
      end
    end
  end
  
end
