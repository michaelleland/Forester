class PageControlsController < ApplicationController
  layout nil
  
  
  def add_specie
    
  end
  
  def delete_specie
    
  end
  
  def import_jobs
    if params[:id] != "0"
      if params[:owner_type] == 1
        @jobs = Job.find_all_by_owner_id(params[:id])
      else
        @jobs = Job.find_all_by_owner_id(params[:id])
      end
      
    end
  end
  
end
