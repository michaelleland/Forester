class SetupController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def jobs
  
  end
  
  def new_job
    @owner = Owner.find_by_name(params[:owner_name])
    @logger = Partner.find_by_name(params[:logger_name])
    @trucker = Partner.find_by_name(params[:trucker_name])
    @job = Job.create(:name => params[:job_name], :owner_id => @owner.id, :hfi_rate => params[:hfi_rate], :hfi_prime => params[:hfi_prime])
    LoggerAssignment.create(:job_id => @job.id, :partner_id => @logger.id)
    TruckerAssignment.create(:job_id => @job.id, :partner_id => @trucker.id)
  end
  
  def show_jobs
    
  end
  
  def owners
  end

  def sawmills
    
  end
  
  def sawmill
    
  end

  def partners
    
  end
end
