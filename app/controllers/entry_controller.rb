class EntryController < ApplicationController
  layout false
  
  def entry

  end
  
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
      @tickets_total_mbf = @tickets_total_mbf + i.net_mbf
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
  
  def add_ticket_entry_row
    @ac = ApplicationController.new
    
    @t_nums = Ticket.all.collect {|i| i.number}
    @t_nums.each do |i|
      if params[:ticket_num] == i.to_s
        render "duplicate_ticket_num.js.erb"
        return
      end
    end
    
    @species = params[:species]
    @mbfs = params[:mbfs]
    
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
    
    @job = Job.find_by_name(params[:job_name])
    @destination = Destination.find_by_name(params[:destination_name])
    
    @ticket = Ticket.create(:delivery_date => "#{@year}-#{@month}-#{@day}", :destination_id => @destination.id, :job_id => @job.id, :number => params[:ticket_num], :value => @value, :wood_type => params[:wood_type], :paid_to_owner => false, :paid_to_logger => false, :paid_to_trucker => false, :mbf_converted = params[:converted].to_i)
    unless params[:wood_type] == "3"
      LoadDetail.create(:ticket_id => @ticket.id, :species_id => @species[0], :tonnage => params[:tonnage], :mbfs => @mbfs[0])  
      @specie_codes.push(Specie.find(@species[0]).code)
      
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
      end
    end
    
    unless @ticket.save
      render :status => 306, :nothing => true
    else
      render :status => 200, :nothing => true
    end
  end
  
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
    
    @total_payment = params[:total_payment].to_s
    3.times do
      @total_payment.sub!(",", "")
    end
    @total_payment = @total_payment.to_f
    
    @payment.total_payment = @total_payment
    
    unless @payment.save
      render :status => 306, :nothing => true
    else
      render :status => 200, :nothing => true
    end
  end

  def delete_ticket
    @ticket = Ticket.find(params[:id])
    @ticket.delete
    
    render :nothing => true
  end

  def delete_payment
    @payment = PaymentFromDestination.find(params[:id])
    @payment.delete
    
    render :nothing => true
  end

end