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
  
  def rates
    
  end

  def new_rate
    @destination = Destination.find_by_name(params[:destination_name])
    @job = Job.find(params[:id])
    @trucker = @job.trucker
    @tr = TruckerRate.create(:destination_id => @destination.id, :job_id => params[:id], :partner_id => @trucker.id, :load_type => params[:load_type], :rate => params[:rate])
  end
  
  def partners
    
  end
end
