class EntryController < ApplicationController
  layout false
  
  def entry

  end
  
  def add_entry_row
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find_by_name(params[:destination_name])
    
    @ticket = Ticket.create(:number => params[:destination_id => @destination.id, :job_id => @job.id, :number => params[:ticket_no], :value => params[:load_pay])
    LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_1], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_1_amount])
    
    @species = [params[:specie_2], params[:specie_3], params[:specie_4], params[:specie_5]]
    @species.delete_id {|x| x == ""}
    @are_there_duplicates = false
    
    if @species.length != @species.uniq.length
      render "duplicates.js.erb"  
    end
    
    
    
    unless 
    unless params[:specie_2] == "" || params[:specie_2].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_2], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_2_amount])
    end
    
    unless params[:specie_3] == "" || params[:specie_3].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_3], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_3_amount])
    end
    
    unless params[:specie_4] == "" || params[:specie_4].nil?
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_4], :wood_type => params[:wood_type], :load_type => params[:load_type], :amount => params[:load_4_amount])
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
