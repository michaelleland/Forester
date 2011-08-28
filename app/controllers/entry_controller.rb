class EntryController < ApplicationController
  layout false
  
  def entry

  end
  
  def add_entry_row
    
    @species = [params[:species_1], params[:species_2], params[:species_3], params[:species_4], params[:species_5]]
    @species.delete_if {|x| x.nil?}    
    
    if @species.length != @species.uniq.length
      render "duplicates.js.erb"
      return 
    end
    
    @params = [params[:ticket_no], params[:load_1_amount], params[:job_name], params[:destination_name], params[:date], params[:load_pay]]
    
    @params.each do |i|
      if i == ""
        render "missing.js.erb"
        return
      end
    end 
    
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find_by_name(params[:destination_name])
    
    @ticket = Ticket.create(:destination_id => @destination.id, :job_id => @job.id, :number => params[:ticket_no], :value => params[:load_pay])
    LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_1], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_1_amount])
   
    unless params[:species_2].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_2], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_2_amount])
    end
    
    unless params[:species_3].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_3], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_3_amount])
    end
    
    unless params[:species_4].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_4], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_4_amount])
    end
    
    unless params[:specie_5] == "" || params[:specie_5].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_5], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_5_amount])
    end
    
  end
  
  def ticket_entry
    @jobs = Job.all
    @loggers = Job.all.collect {|i| i.logger }.flatten.uniq
    @destinations = Destination.all
  end
  
  def payment_entry
    @jobs = Job.all
    @loggers = Job.all.collect {|i| i.logger }.flatten.uniq
    @destinations = Destination.all
  end  
  
end
