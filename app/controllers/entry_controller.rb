class EntryController < ApplicationController
  layout false
  
  def entry

  end
  
  def add_ticket_entry_row
    @t_nums = Ticket.all.collect {|i| i.number}
    @t_nums.each do |i|
      if params[:ticket_num] == i.to_s
        render "duplicate_ticket_num.js.erb"
        return
      end
    end
    
    @species = [params[:species_1], params[:species_2], params[:species_3], params[:species_4], params[:species_5]]
    @species.delete_if {|x| x.nil?}    
    
    if @species.length != @species.uniq.length
      render "duplicates.js.erb"
      return 
    end
    
    @params = [params[:ticket_num], params[:load_1_amount], params[:job_name], params[:destination_name], params[:date], params[:load_pay]]
    
    @params.each do |i|
      if i == ""
        render "missing.js.erb"
        return
      end
    end 
    
    @specie_codes = []
    
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find_by_name(params[:destination_name])
    
    @ticket = Ticket.create(:delivery_date => params[:delivery_date], :destination_id => @destination.id, :job_id => @job.id, :number => params[:ticket_num], :value => params[:value], :wood_type => params[:wood_type], :paid_to_owner => false, :paid_to_logger => false, :paid_to_trucker => false)
    unless params[:wood_type] == "3"
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_1], :tonnage => params[:tonnage], :mbfs => params[:load_1_mbfs])  
      @specie_codes.push(Specie.find(params[:species_1]).code)
      unless params[:species_2].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_2], :mbfs => params[:load_2_mbfs])
        @specie_codes.push(Specie.find(params[:species_2]).code)
      end
    
      unless params[:species_3].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_3], :mbfs => params[:load_3_mbfs])
        @specie_codes.push(Specie.find(params[:species_3]).code)
      end
    
      unless params[:species_4].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:species_4], :mbfs => params[:load_4_mbfs])
        @specie_codes.push(Specie.find(params[:species_4]).code)
      end
    
      unless params[:specie_5].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => params[:specie_5], :mbfs => params[:load_5_mbfs])
        @specie_codes.push(Specie.find(params[:species_5]).code)
      end
    else
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => 0, :tonnage => params[:tonnage])
    end 
  end
  
  def add_payment_entry_row
    @destination = Destination.find_by_name(params[:destination_name])
    @job = Job.find_by_name(params[:job_name])
    
    @pfd = PaymentFromDestination.create(:payment_date => params[:payment_date], :payment_num => params[:payment_num], :destination_id => @destination.id, :job_id => @job.id, :tickets => params[:tickets], :net_mbf => params[:net_mbf], :tonnage =>  params[:tonnage], :total_payment => params[:total_payment], :wood_type => params[:wood_type])
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
  
  def delete_ticket_entry
    @ticket = Ticket.find(params[:id])
    @ticket.load_details.each do |i|
      i.delete
    end
    if @ticket.delete 
      render :nothing => true
    end
  end
  
  def delete_payment_entry
    @pfd = PaymentFromDestination.find(params[:id])
    if @pfd.delete 
      render :nothing => true
    else
      render :state => 13
    end
  end
  
end
