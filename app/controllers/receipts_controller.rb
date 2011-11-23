class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def new_statement
    
  end
  
  def get_statement
    @job = Job.find(params[:id])
    @ac = ApplicationController.new
    @receipts
    @owner_type = params[:type]
    @owner
    
    if params[:type] == "owner"
      @owner = @job.owner
      @receipts = @job.receipts.collect {|i| if i.owner_type == "owner" then i else 0 end }
    end
    if params[:type] == "logger"
      @owner = @job.logger
      @logger = @owner
      @receipts = @job.receipts.collect {|i| if i.owner_type == "logger" then i else 0 end }
    end
    if params[:type] == "trucker"
      @owner = @job.trucker
      @trucker = @owner
      @receipts = @job.receipts.collect {|i| if i.owner_type == "trucker" then i else 0 end }
    end
    
    @receipts.delete_if {|i| i == 0 }
    
    @tickets = @receipts.collect {|i| i.tickets }
    @tickets.flatten!
    
    @total = 0
    @receipts.each {|i| @total = @total + i.payment_total}
    @total = @ac.give_pennies(@total)
    
    @deductions = []
    @receipts.each do |i|
      i.receipt_items.each do |j|
        @deductions.push(j)
      end
    end
    
    @ded_total = 0
    @deductions.each do |i|
      @ded_total = @ded_total + i.value
    end
    
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
  
    @destinations = Destination.find(@destination_ids)
    
    @trucker_total = 0
    @logger_total = 0
    @owner_total = 0
    @hfi_total = 0
    @load_pay_total = 0
    
    @tickets.each do |j|
        @load_pay_total = @load_pay_total + j.value
        
        @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
        if @rate.rate_type == "MBF"
          j.trucker_value = @rate.rate * j.net_mbf
        else
          if @rate.rate_type == "Tonnage"
            j.trucker_value = @rate.rate * j.tonnage
          else 
            if @rate.rate_type == "percent"
              j.trucker_value = (@rate.rate / 100) * j.value
            end
          end
        end
          
        @trucker_total = @trucker_total + j.trucker_value
        
        j.hfi_value = j.value * (@job.hfi_rate / 100)
        @hfi_total = @hfi_total + j.hfi_value 
        
        @destinations.each do |i|
          if j.destination_id == i.id
            @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, j.job_id, @job.logger.id)
            if @rate.rate_type == "MBF"
              j.logger_value = @rate.rate * j.net_mbf
            else
              if @rate.rate_type == "Tonnage"
                j.logger_value = @rate.rate * j.tonnage
              else @rate.rate_type == "percent"
                if 
                  j.logger_value = (@rate / 100) *j.value
                end
              end
            end
          end
        end
        
        @logger_total = @logger_total + j.logger_value
        
        j.owner_value = j.value - j.logger_value - j.trucker_value - j.hfi_value
        @owner_total = @owner_total + j.owner_value
      end
  end
  
  
  def search_statement
    
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
  
  require 'base64'
  
  def get_pdf_receipt
    @url = params[:url]
    
    @kit = PDFKit.new(Base64.decode64(@url))
    
    @filename = "#{Time.now.strftime("%Y%m%d-%H%M%S")}trucker.pdf"
    @filepath = "#{Rails.root}/public/pdfs/#{@filename}"
    @kit.to_pdf
    @file = @kit.to_file(@filepath)
    send_data(@file.read, :type => "pdf", :filename => @filename)
  end
  
  def get_owner_receipt
    @tickets = Ticket.find(params[:tickets])
    @job = Job.find(@tickets.first.job_id)
    @owner = @job.owner
    
    @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("owner", @owner.id, @job.id, :order => "payment_num")
    unless @receipts.first.nil?
      @payment_num = @receipts.last.payment_num + 1
    else
      @payment_num = 1
    end
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    respond_to do |format|
      format.pdf do
        #save_trucker_receipt(@tickets, @payment_num, @deduction_items, @notes)
        pdf = LandownerReceipt.new(@tickets, @payment_num, @deduction_items, @notes)
        send_data pdf.render, filename: "#{@job.name}_#{@payment_num}_landowner_receipt",
                              type: "application/pdf",
                              disposition: "inline"
      end 
    end
  end
  
  def logger_receipt
  
  end
  
  def get_logger_receipt
    @tickets = Ticket.find(params[:tickets])
    @notes = params[:notes]
    @job = Job.find(@tickets.first.job_id)
    @logger = @job.logger
    
    @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("logger", @logger.id, @job.id, :order => "payment_num")
    unless @receipts.first.nil?
      @payment_num = @receipts.last.payment_num + 1
    else
      @payment_num = 1
    end
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    respond_to do |format|
      format.pdf do
        pdf = LoggerReceipt.new(@tickets, @payment_num, @deduction_items, @notes)
        send_data pdf.render, filename: "#{@job.name}_#{@payment_num}_logger_receipt",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def trucker_receipt
    
  end
  
  def get_trucker_receipt
    @tickets = Ticket.find(params[:tickets])
    @job = Job.find(@tickets.first.job_id)     
    @trucker = @job.trucker
     
    if @payment_num.nil?
      @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("trucker", @trucker.id, @job.id, :order => "payment_num")
      unless @receipts.first.nil?
        @payment_num = @receipts.last.payment_num + 1
      else
        @payment_num = 1
      end
    end
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    @notes = params[:notes]
    
    respond_to do |format|
      format.pdf do
        #save_trucker_receipt(@tickets, @payment_num, @deduction_items, @notes)
        pdf = TruckerReceipt.new(@tickets, @payment_num, @deduction_items, @notes)
        send_data pdf.render, filename: "#{@job.name}_#{@payment_num}_trucker_receipt}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def save_owner_receipt    
    @tickets = Ticket.find(params[:tickets])
    
    if @tickets.first.paid_to_owner == true
      render :nothing => true, :state => 500
      return
    end
    
    @job = Job.find(@tickets.first.job_id)
    @trucker = @job.trucker
    
    @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("trucker", @trucker.id, @job.id, :order => "payment_num")
    unless @receipts.first.nil?
      @payment_num = @receipts.last.payment_num + 1
    else
      @payment_num = 1
    end
    
    @receipt = Receipt.create(:job_id => @tickets.first.job_id, :payment_num => @payment_num, :owner_id => params[:owner_id], :owner_type => "owner", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes], :payment_total => params[:payment_total]);
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_owner = true
      i.save
    end
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
      end
    end
  end
  
  def save_logger_receipt    
    @tickets = Ticket.find(params[:tickets])
    
    if @tickets.first.paid_to_logger == true
      render :nothing => true, :state => 500
      return
    end
    
    @payment_num = params[:payment_num]
    
    @receipt = Receipt.create(:job_id => @tickets.first.job_id, :payment_num => @payment_num, :owner_id => params[:logger_id], :owner_type => "logger", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes], :payment_total => params[:payment_total]);
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_logger = true
      i.save
    end
    
    @deduction_items = []
    @deduction_items.push([i, params[:deductions_values][x]])
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
      end
    end
    
    pdf = LoggerReceipt.new(@tickets, @payment_num, @deduction_items, @notes)
    send_data pdf.render, filename: "#{@job.name}_#{@payment_num}_trucker_receipt",
                           type: "application/pdf"
  end
  
  def save_trucker_receipt
    @tickets = Ticket.find(params[:tickets])
    if @tickets.first.paid_to_trucker == true
      render :nothing => true, :state => 500
      return
    end
    
    @notes = params[:notes]
    @job = Job.find(@tickets.first.job_id)
    @trucker = @job.trucker
    
    @receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("trucker", @trucker.id, @job.id, :order => "payment_num")
    unless @receipts.first.nil?
      @payment_num = @receipts.last.payment_num + 1
    else
      @payment_num = 1
    end
    
    @receipt = Receipt.create(:job_id => @job.id, :payment_num => @payment_num, :owner_id => @trucker.id, :owner_type => "trucker", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => @notes, :payment_total => @payment_total);
    
    @tickets.each do |i|
      @receipt.tickets.push(i)
      i.paid_to_trucker = true
      i.save
    end
    
    #Need by the pdf
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @receipt.receipt_items.push(ReceiptItem.create(:item_data => i, :value => params[:deductions_values][x]))
        @deduction_items.push([i, params[:deductions_values][x]])
      end
    end
    
    pdf = TruckerReceipt.new(@tickets, @payment_num, @deduction_items, @notes)
    send_data pdf.render, filename: "#{@job.name}_#{@payment_num}_trucker_receipt",
                           type: "application/pdf"
  end
  
  def delete_trucker_receipt
    @receipt = Receipt.find(params[:receipt_id])
    
    @receipt.tickets.each do |i|
      i.paid_to_trucker = false
      i.save
    end
    
    @receipt.receipt_items.each do |i|
      i.delete
    end
    
    @receipt.delete
    
    render :nothing => true
  end
  
  def get_old_receipt
    @receipt = Receipt.find(params[:receipt_id])
    @job = Job.find(@receipt.job_id)
    @payment_num = @receipt.payment_num
    @notes = @receipt.notes
    @tickets = @receipt.tickets
    @date_string = @receipt.receipt_date.strftime("%m/%d/%Y")
    @ac = ApplicationController.new
    @old = "Im not OLD!" #Yeah yeah, that's what they always say...
      
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
  
    @destinations = Destination.find(@destination_ids)
      
    if params[:owner_type] == "landowner"
      @total_wo_deductions = 0
      @total = 0
      @trucker_total = 0
      @logger_total = 0
      @hfi_total = 0
      @load_pay_total = 0
      
      @tickets.each do |j|
        @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
        if @rate.rate_type == "MBF"
          j.trucker_value = @rate.rate * j.net_mbf
        else
          if @rate.rate_type == "Tonnage"
            j.trucker_value = @rate.rate * j.tonnage
          else 
            if @rate.rate_type == "percent"
              j.trucker_value = (@rate.rate / 100) * j.value
            end
          end
        end
          
        @trucker_total = @trucker_total + j.trucker_value
        
        j.hfi_value = j.value * (@job.hfi_rate / 100)
        @hfi_total = @hfi_total + j.hfi_value
        
        @destinations.each do |i|
          if j.destination_id == i.id
            @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, j.job_id, @job.logger.id)
            if @rate.rate_type == "MBF"
              j.logger_value = @rate.rate * j.net_mbf
            else
              if @rate.rate_type == "Tonnage"
                j.logger_value = @rate.rate * j.tonnage
              else @rate.rate_type == "percent"
                if 
                  j.logger_value = (@rate / 100) *j.value
                end
              end
            end
          end
        end

        @logger_total = @logger_total + j.logger_value
      
        j.owner_value = j.value - j.logger_value - j.trucker_value - j.hfi_value
      end
      
      @tickets.each {|i| @total = @total + i.owner_value.to_f }
    
      @total_wo_deductions = give_pennies(@total)
      
      @deduction_items = []
      
      unless @receipt.receipt_items.nil?
        @receipt.receipt_items.each_with_index do |i|
          @deduction_items.push([i.item_data, i.value])
        end     
      end
        
      @deduction_items.each {|i| @total = @total - i[1].to_f }
      
      @total = give_pennies(@total)
      
      render "get_owner_receipt.html.erb"
    end
    if params[:owner_type] == "logger"
      
      @logger = @job.logger
      
      @total_wo_deductions = 0
      @total = 0
      @logger_total = 0
      @load_pay_total = 0
      
      @tickets.each do |j|      
        @destinations.each do |i|
          if j.destination_id == i.id
            @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, j.job_id, @job.logger.id)
            if @rate.rate_type == "MBF"
              j.logger_value = @rate.rate * j.net_mbf
            else
              if @rate.rate_type == "Tonnage"
                j.logger_value = @rate.rate * j.tonnage
              else @rate.rate_type == "percent"
                if 
                  j.logger_value = (@rate / 100) *j.value
                end
              end
            end
          end
        end

        @logger_total = @logger_total + j.logger_value
        
      end
      
      @total = @logger_total
      
      @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
      
      @total_wo_deductions = give_pennies(@total)
      
      @deduction_items = []
      
      unless @receipt.receipt_items.nil?
        @receipt.receipt_items.each_with_index do |i|
          @deduction_items.push([i.item_data, i.value])
        end     
      end
        
      @deduction_items.each {|i| @total = @total - i[1].to_f }
      
      @total = give_pennies(@total)
      
      render "get_logger_receipt.html.erb"      
    end
    if params[:owner_type] == "trucker"
      
      @total_wo_deductions = 0
      @total = 0
      @trucker_total = 0
      @load_pay_total = 0
      
      @trucker = @job.trucker
      
      @tickets.each do |j|
        @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
        if @rate.rate_type == "MBF"
          j.trucker_value = @rate.rate * j.net_mbf
        else
          if @rate.rate_type == "Tonnage"
            j.trucker_value = @rate.rate * j.tonnage
          else 
            if @rate.rate_type == "percent"
              j.trucker_value = (@rate.rate / 100) * j.value
            end
          end
        end
        
        @trucker_total = @trucker_total + j.trucker_value
        
      end
      
      @tickets.each {|i| @load_pay_total = @load_pay_total + i.value.to_f }
      
      @deduction_items = []
      
      unless @receipt.receipt_items.nil?
        @receipt.receipt_items.each_with_index do |i|
          @deduction_items.push([i.item_data, i.value])
        end     
      end
      @total = @trucker_total
      @total_wo_deductions = @trucker_total
        
      @deduction_items.each {|i| @total = @total - i[1].to_f }
      
      @total = give_pennies(@total)
      
      render "get_trucker_receipt.html.erb"
    end
  end
  
end
