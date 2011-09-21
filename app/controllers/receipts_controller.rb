class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
  end
 
  def search_receipt
    
  end
 
  def owner_receipt
  end
  
  def add_deduction
    @receipt_item = ReceiptItem.create(:item_data => params[:data], :receipt_id => 0, :value => params[:deduction_amount])
  end
  
  class Payment
    attr_accessor :number, :value
  end
  
  def get_owner_receipt
    #Some utility vars
    @time = Time.now
    @ac = ApplicationController.new
    
    #end utils
    
    #Total vars declared and initialized
    
    @trucker_total = 0
    @logger_total = 0 
    @hfi_total = 0
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)
    @total_wo_deductions #Owners total without deductions.
    
    @tickets = Ticket.find(params[:tickets])
    
    @job = Job.find(@tickets.first.job_id)
    @owner = @job.owner
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    @payment_num = params[:payment_num]
    
    if @payment_num .nil?
      @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("landowner", @owner.id, @job.id, :order => "payment_num")
      unless @receipts.first.nil?
        @payment_num = @receipts.last.payment_num + 1
      else
        @payment_num = 1
      end
    end
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
    @tickets.each do |j|
      @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
      if j.load_type == "MBF"
        j.trucker_value = @rate.rate * j.net_mbf
      else
        if j.load_type == "Tonnage"
          j.trucker_value = @rate.rate * j.tonnage
        end
      end
      
      @trucker_total = @trucker_total + j.trucker_value
      
      j.hfi_value = j.value * (@job.hfi_rate / 100)
      @hfi_total = @hfi_total + j.hfi_value
      
      @destinations.each do |i|
        if j.destination_id == i.id
          @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, @job.id, @job.logger.id)
          unless @rate.is_percent?
            if i.accepted_load_type == "MBF"
              j.logger_value = @rate.rate * j.net_mbf
            else
              if i.accepted_load_type == "Tonnage"
                j.logger_value = @rate.rate * j.tonnage
              end
            end
          else
            j.logger_value = j.value * (@rate / 100)
          end
        end
      end
      
      @logger_total = @logger_total + j.logger_value
      
      j.owner_value = j.value - j.logger_value - j.trucker_value - j.hfi_value
    end
    
    @tickets.each {|i| @total = @total + i.owner_value.to_f }
    
    @total_wo_deductions = give_pennies(@total)
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
      
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
    @total = give_pennies(@total)
  end
  
  def logger_receipt
  
  end
  
  def get_logger_receipt
    #Some utility vars
    @time = Time.now
    @ac = ApplicationController.new
    
    #end utils
    
    #Total vars declared and initialized
    
    @logger_total = 0 
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)
    @total_wo_deductions #Loggers total without deductions.
    
    @tickets = Ticket.find(params[:tickets])
    
    @job = Job.find(@tickets.first.job_id)
    @logger = @job.logger
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    @next_num = 1
    @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("logger", @logger.id, @job.id, :order => "payment_num")
    unless @receipts.first.nil?
      @next_num = @receipts.last.payment_num + 1
    end
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
    @tickets.each do |j|      
      @destinations.each do |i|
        if j.destination_id == i.id
          @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, @job.id, @job.logger.id)
          unless @rate.is_percent?
            if i.accepted_load_type == "MBF"
              j.logger_value = @rate.rate * j.net_mbf
            else
              if i.accepted_load_type == "Tonnage"
                j.logger_value = @rate.rate * j.tonnage
              end
            end
          else
            j.logger_value = j.value * (@rate / 100)
          end
        end
      end
      
      @logger_total = @logger_total + j.logger_value
      
    end
    
    @total = @logger_total
    
    @tickets.each {|i| @total = @total + i.owner_value.to_f }
    
    @total_wo_deductions = give_pennies(@total)
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
      
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
    @total = give_pennies(@total)
  end
  
  def trucker_receipt
    
  end
  
  def get_trucker_receipt
    #Some utility vars
    @time = Time.now
    @ac = ApplicationController.new
    
    #end utils
    
    #Total vars declared and initialized
    
    @trucker_total = 0     
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)   
    
    @tickets = Ticket.find(params[:tickets])
    
    @job = Job.find(@tickets.first.job_id)
    @trucker = @job.trucker
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    @payment_num = params[:payment_num]
    
    if @payment_num.nil?
      @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("landowner", @trucker.id, @job.id, :order => "payment_num")
      unless @receipts.first.nil?
        @payment_num = @receipts.last.payment_num + 1
      else
        @payment_num = 1
      end
    end
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
    @tickets.each do |j|
      @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @trucker.id, j.destination_id)
      if j.load_type == "MBF"
        j.trucker_value = @rate.rate * j.net_mbf
      else
        if j.load_type == "Tonnage"
          j.trucker_value = @rate.rate * j.tonnage
        end
      end
      
      @trucker_total = @trucker_total + j.trucker_value
      
    end
    
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.owner_value.to_f }
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    @total = @trucker_total
      
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
    @total = give_pennies(@trucker_total)
  end
  
  def save_owner_receipt    
    @tickets = Ticket.find(params[:tickets])
    
    @payment_num = params[:payment_num]
    
    @receipt = Receipt.create(:job_id => @tickets.first.job_id, :payment_num => @payment_num, :owner_id => params[:owner_id], :owner_type => "landowner", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes]);
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_owner = true
      i.save
    end
    
    params[:deductions_list].each_with_index do |i, x|
      @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
    end
    
  end
  
    def save_logger_receipt    
    @tickets = Ticket.find(params[:tickets])
    
    @payment_num = params[:payment_num]
    
    @receipt = Receipt.create(:job_id => @tickets.first.job_id, :payment_num => @payment_num, :owner_id => params[:owner_id], :owner_type => "logger", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes]);
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_logger = true
      i.save
    end
    
    params[:deductions_list].each_with_index do |i, x|
      @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
    end
    
  end
  
    def save_trucker_receipt    
    @tickets = Ticket.find(params[:tickets])
    
    @payment_num = params[:payment_num]
    
    @receipt = Receipt.create(:job_id => @tickets.first.job_id, :payment_num => @payment_num, :owner_id => params[:owner_id], :owner_type => "trucker", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes]);
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_trucker = true
      i.save
    end
    
    params[:deductions_list].each_with_index do |i, x|
      @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
    end
    
  end
end
