class EntryController < ApplicationController
  layout false
  
  def entry
    
  end
  
  #View action
  #Pulls all tickets and payments from DB, collects data from the records
  # and makes calculations
  def comparison
    @tickets = Ticket.all
    @payments = PaymentFromDestination.all
    
    @tickets_in_payments = 0
    @payments.each do |i|
      @tickets_in_payments = @tickets_in_payments + i.tickets
    end
    
    @tickets_total = 0
    @tickets_total_mbf = 0
    @tickets_total_tonnage = 0
    
    @tickets.each do |i| 
      @tickets_total = @tickets_total + i.value
      unless i.mbf_converted
        @tickets_total_mbf = @tickets_total_mbf + i.net_mbf
      end
      @tickets_total_tonnage = @tickets_total_tonnage + i.tonnage
    end
    
    @payments_total = 0
    @payments_total_mbf = 0
    @payments_total_tonnage = 0
    
    @payments.each do |i| 
      @payments_total = @payments_total + i.total_payment
      @payments_total_mbf = @payments_total_mbf + i.net_mbff
      @payments_total_tonnage = @payments_total_tonnage + i.tonnnage
    end
    
    @value_diff = @tickets_total - @payments_total
    @mbf_diff = @tickets_total_mbf - @payments_total_mbf
    @tonnage_diff = @tickets_total_tonnage - @payments_total_tonnage
  end
  
  #Ajax action
  #Creates a ticket and returns a html ul list row with the data of the new ticket
  def add_ticket_entry_row
    @ac = ApplicationController.new
    
    #Checks if there already is a ticket with the given number
    #If there is, a js is rendered which lets user know of it.
    @t_nums = Ticket.all.collect {|i| i.number}
    @t_nums.each do |i|
      if params[:ticket_num] == i.to_s
        render "duplicate_ticket_num.js.erb"
        return
      end
    end
    
    @species = params[:species]
    @mbfs = params[:mbfs]
    
    #If there are multiple species in a load and the data contains two species - mbf pairs
    # where species is the same, a js is rendered which lets user to know of it.
    if @species.length != @species.uniq.length
      render "duplicates.js.erb"
      return
    end
    
    @value = params[:value].to_s
    3.times do
      @value.sub!(",", "")
    end
    @value = @value.to_f
    
    @day = params[:delivery_date][3..4]
    @month = params[:delivery_date][0..1]
    @year = params[:delivery_date][6..9]
    
    @specie_codes = []
    
    converted = false
    if params[:converted] == "1"
      converted = true
    end
    
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find(params[:destination_id])
    
    @ticket = Ticket.create(:delivery_date => "#{@year}-#{@month}-#{@day}", :destination_id => @destination.id, :job_id => @job.id, :number => params[:ticket_num], :value => @value, :wood_type => params[:wood_type], :paid_to_owner => false, :paid_to_logger => false, :paid_to_trucker => false, :paid_to_hfi => false, :mbf_converted => converted)
    
    unless params[:wood_type] == "3" #wood type 3 means pulp
      #One load detail for one ticket is created in any case
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species.first, :tonnage => params[:tonnage], :mbfs => @mbfs[0])  
      @specie_codes.push(Specie.find(@species[0]).code)
      
      #But if there is more, so many load details will be created
      unless @species[1].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species[1], :mbfs => @mbfs[1])
        @specie_codes.push(Specie.find(@species[1]).code)
      end
      
      unless @species[2].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species[2], :mbfs => @mbfs[2])
        @specie_codes.push(Specie.find(@species[2]).code)
      end
      
      unless @species[3].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species[3], :mbfs => @mbfs[3])
        @specie_codes.push(Specie.find(@species[3]).code)
      end
      
      unless @species[4].nil?
        LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species[4], :mbfs => @mbfs[4])
        @specie_codes.push(Specie.find(@species[4]).code)
      end
    else
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => 0, :tonnage => params[:tonnage])
    end
  end
  
  #Ajax action
  #Creates a payment and returns a html ul list row with the data of the new ticket
  def add_payment_entry_row
    @ac = ApplicationController.new
    
    @day = params[:payment_date][3..4]
    @month = params[:payment_date][0..1]
    @year = params[:payment_date][6..9]
    
    @total_payment = params[:amount].to_s
    3.times do
      @total_payment.sub!(",", "")
    end
    @total_payment = @total_payment.to_f
    
    @pfd = PaymentFromDestination.create(:payment_date => "#{@year}-#{@month}-#{@day}", :payment_num => params[:payment_num], :destination_id => params[:destination_id], :job_id => params[:job_id], :tickets => params[:tickets], :net_mbf => params[:net_mbf], :tonnage =>  params[:tonnage], :total_payment => @total_payment, :wood_type => params[:wood_type])
  end
  
  #Show action
  #The rendered html of this file contains the ticket entry inputs and the all tickets section
  # and the latter is initially empty
  def ticket_entry
    @jobs = Job.all
    @loggers = Job.all.collect {|i| i.logger }.flatten.uniq
    @destinations = Destination.all
  end
  
  #Show action
  #Same as above, but for payments
  def payment_entry
    @jobs = Job.all
    @loggers = Job.all.collect {|i| i.logger }.flatten.uniq
    @destinations = Destination.all
  end 
  
  #Ajax action
  #Searches for a ticket with given id and saves the given values to it
  # despite the fact that they might be the same as the old ones
  def save_edited_ticket_entry
    @raw_date = params[:delivery_date]
    
    @day = @raw_date[3..4]
    @month = @raw_date[0..1]
    @year = @raw_date[6..9]
    
    @delivery_date = "#{@year}-#{@month}-#{@day}"
    
    @ticket = Ticket.find(params[:id])
    @ticket.number = params[:ticket_num]
    @ticket.delivery_date = @delivery_date
    @ticket.job_id = params[:job_id]
    @ticket.destination_id = params[:destination_id]
    @ticket.wood_type = params[:wood_type_id]
    
    #Because the tickets value (load pay) comes in as string in currency format
    # some parts have to be stripped off to be able to turn it into float correctly 
    @value = params[:value].to_s
    3.times do
      @value.sub!(",", "")
    end
    @value = @value.to_f
    
    @ticket.value = @value
    
    @ticket.load_details.each_with_index do |i, x|
      i.species_id = params[:species][x]
      i.tonnage = params[:tons][x]
      i.mbfs = params[:mbfs][x]
      
      unless i.save
        render :status => 306, :nothing => true
        return
      end
    end
    
    unless @ticket.save
      render :status => 306, :nothing => true
    else
      render :status => 200, :nothing => true
    end
  end
  
  #Ajax action
  #Same as above, but for payment
  def save_edited_payment_entry
    @raw_date = params[:payment_date]
    
    @day = @raw_date[3..4]
    @month = @raw_date[0..1]
    @year = @raw_date[6..9]
    
    @payment_date = "#{@year}-#{@month}-#{@day}"
    
    @payment = PaymentFromDestination.find(params[:id])
    @payment.job_id = params[:job_id]
    @payment.destination_id = params[:destination_id]
    @payment.payment_date = @payment_date
    @payment.payment_num = params[:payment_num]
    @payment.wood_type = params[:wood_type_id]
    @payment.tickets = params[:tickets]
    @payment.tonnage = params[:tons]
    @payment.net_mbf = params[:mbf]
    
    #Because the total payment comes in as string in currency format
    # some parts have to be stripped off to be able to turn it into float correctly
    @total_payment = params[:total_payment].to_s
    3.times do
      @total_payment.sub!(",", "")
    end
    @total_payment = @total_payment.to_f
    
    @payment.total_payment = @total_payment
    
    unless @payment.save
      render :status => 306, :nothing => true
      return
    else
      render :status => 200, :nothing => true
      return
    end
  end

  #Ajax action
  #Deletes a ticket with given id
  def delete_ticket
    @ticket = Ticket.find(params[:id])
    @ticket.delete
    
    render :nothing => true
  end
  
  #Ajax action
  #Deletes a payment with given id
  def delete_payment
    @payment = PaymentFromDestination.find(params[:id])
    @payment.delete
    
    render :nothing => true
  end
  
  def is_this_tn_duplicate
    if params[:ticket_id].nil?
      if Ticket.find_by_number(params[:id]).nil?
        render :text => "false"
      else
        render :text => "true"
      end
    else
      if Ticket.find(params[:ticket_id]).number == params[:id].to_i
        render :text => "false"
      else
        if Ticket.find_by_number(params[:id]).nil?
          render :text => "false"
        else
          render :text => "true"
        end
      end     
    end
    
  end
end