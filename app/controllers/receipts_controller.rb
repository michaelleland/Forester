class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def new_statement
    
  end
  
  #Ajax action
  #Renders a PDF statement of given user and given owner type (landowner, logger, trucker, hfi) 
  def get_statement
    job = Job.find(params[:id])
    
    receipts = []
    receipts = job.receipts.collect {|i| if i.owner_type == params[:type] then i else 0 end }
    
    receipts.delete_if {|i| i == 0 }
    
    deduction_items = []
    receipts.each do |i|
      i.receipt_items.each do |j|
        deduction_items.push([j.item_data, j.value, i.payment_num])
      end
    end
    
    if params[:type] == "owner"
      respond_to do |format|
        format.pdf do
        pdf = LandownerStatement.new(receipts, deduction_items, view_context)
        send_data pdf.render, filename: "#{job.name}_landowner_statement",
                              type: "application/pdf"
        end 
      end
    end
    if params[:type] == "logger"
      respond_to do |format|
        format.pdf do
          pdf = LoggerStatement.new(receipts, deduction_items, view_context)
          send_data pdf.render, filename: "#{job.name}_logger_statement",
                              type: "application/pdf"
        end 
      end
    end
    if params[:type] == "trucker"
      respond_to do |format|
      format.pdf do
        pdf = TruckerStatement.new(receipts, deduction_items, view_context)
        send_data pdf.render, filename: "#{job.name}_trucker_statement",
                              type: "application/pdf"
        end 
      end
    end
    if params[:type] == "hfi"
      respond_to do |format|
        format.pdf do
        pdf = HFIStatement.new(receipts, view_context)
        send_data pdf.render, filename: "#{job.name}_hfi_statement",
                              type: "application/pdf"
        end 
      end
    end
  end
  
  #Ajax action
  #Return statuscode 200 if there are receipts for given job and given owner type(same as above)
  #If not, returns error. Js in browser knows how to handle them.
  def check_for_receipts
    receipts = Receipt.find_all_by_job_id_and_owner_type(params[:id], params[:type])
    if receipts.length == 0
      render :nothing => true, :status => 500
    else
      render :nothing => true
    end
  end
  
  def search_statement
    
  end
  
  def search_receipt
    
  end
 
  def owner_receipt
  
  end
  
  #Utility class
  class Payment
    attr_accessor :number, :value
  end
  
  #Ajax action
  #Gathers up the tickets for the receipt and resolves payment number for the payment/receipt
  #Passes the data to a new instance of corresponding PDF class. That is rendered to user.
  def get_owner_receipt
    tickets = Ticket.find(params[:tickets])
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    notes = params[:notes]
    
    #Payment number is one greater than the payment number in the latest receipt
    #If it does not exits, this is the first receipt if this type and so payment number is 1.
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("owner", owner.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    #Deduction items, when it's populated, is a two dimensional array. The acutal deductions
    # consist of [Name, value] "pairs". 
    deduction_items = []
    
    #Deduction items is populated here, using data from params arrays.
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    #The ajax call from browser uses pdf format so we respond to that.
    respond_to do |format|
      format.pdf do
        pdf = LandownerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
        send_data pdf.render, filename: "#{job.name}_#{payment_num}_landowner_receipt",
                              type: "application/pdf",
                              disposition: "inline" #PDF will be shown in the browser
      end 
    end
  end
  
  #Ajax action
  #Same as above
  def get_logger_receipt
    tickets = Ticket.find(params[:tickets])
    notes = params[:notes]
    job = Job.find(tickets.first.job_id)
    logger = job.logger
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("logger", logger.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    respond_to do |format|
      format.pdf do
        pdf = LoggerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
        send_data pdf.render, filename: "#{job.name}_#{payment_num}_logger_receipt",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  
  #Ajax action
  #Same as above
  def get_trucker_receipt
    tickets = Ticket.find(params[:tickets])
    job = Job.find(tickets.first.job_id)     
    trucker = job.trucker
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("trucker", trucker.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
    
    notes = params[:notes]
    
    respond_to do |format|
      format.pdf do
        pdf = TruckerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
        send_data pdf.render, filename: "#{job.name}_#{payment_num}_trucker_receipt}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  #Ajax action
  #Same as above with exception that hfi receipts don't contain deduction items  
  def get_hfi_receipt
    tickets = Ticket.find(params[:tickets])
    job = Job.find(tickets.first.job_id)
    notes = params[:notes]
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("hfi", 0, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    respond_to do |format|
      format.pdf do
        pdf = HFIReceipt.new(tickets, payment_num, notes, view_context)
        send_data pdf.render, filename: "#{job.name}_#{payment_num}_hfi_receipt",
                              type: "application/pdf",
                              disposition: "inline"
      end 
    end
  end
  
  #Ajax action
  #Does the same calculations which are done in the receipt PDF classes, but now for saving the same data
  # into database so it can be later on pulled out and used to recreate the old receipts.
  #Some of the things happening here are already described in the previous actions. See also the documentation
  # in the PDF receipt classes.
  def save_owner_receipt
    tickets = Ticket.find(params[:tickets])
    
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    notes = params[:notes]
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("owner", owner.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    payment_total = 0
    
    tickets.each do |i|    
      if i.logger_rate.rate_type == "MBF"
        i.logger_value = i.logger_rate.rate*i.net_mbf
      else
        if i.logger_rate.rate_type == "Tonnage"
          i.logger_value = i.logger_rate.rate*i.tonnage
        else
          i.logger_value = (i.logger_rate.rate/100)*i.value
        end
      end
      
      if i.trucker_rate.rate_type == "MBF"
        i.trucker_value = i.trucker_rate.rate*i.net_mbf
      else
        if i.trucker_rate.rate_type == "Tonnage"
          i.trucker_value = i.trucker_rate.rate*i.tonnage
        else
          i.trucker_value = (i.trucker_rate.rate/100)*i.value
        end
      end
      
      i.hfi_value = (job.hfi_rate/100)*i.value
      
      i.owner_value = i.value - i.hfi_value - i.logger_value - i.trucker_value
      payment_total = payment_total + i.owner_value.round(2)
      payment_total = payment_total.round(2)
    end
    
    #Needed by the pdf
    deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end
    end
    
    unless deduction_items.first.nil?
      deduction_items.each do |i| 
        payment_total = payment_total - i[1].to_f.round(2)
      end
    end
    
    payment_total = payment_total.round(2)
    
    receipt = Receipt.create(:job_id => tickets.first.job_id, :payment_num => payment_num, :owner_id => owner.id, :owner_type => "owner", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => params[:notes], :total_payment => payment_total)
    tickets.each do |i|
      receipt.tickets.push(i)
      i.paid_to_owner = true
      i.save
    end
    
    unless deduction_items.first.nil?
      deduction_items.each do |i| 
        receipt.receipt_items.create(:item_data => i[0], :value => i[1])
      end
    end
    
    pdf = LandownerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
    send_data pdf.render, filename: "#{job.name}_#{payment_num}_logger_receipt",
                           type: "application/pdf"
  end
  
  #Ajax action
  #Same as above
  def save_logger_receipt    
    tickets = Ticket.find(params[:tickets])
    notes = params[:notes]
    job = Job.find(tickets.first.job_id)
    logger = job.logger
    
    if tickets.first.paid_to_logger == true
      render :nothing => true, :state => 500
      return
    end
    
    deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end
    end
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("logger", logger.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    load_pay_total = 0
    
    tickets.each do |i|
      load_pay_total = load_pay_total + round_to(i.value, 2)
      load_pay_total = round_to(load_pay_total, 2)
    end
    
    logger_total = 0
    
    tickets.each do |i|
      if i.logger_rate.rate_type == "MBF"
        i.logger_value = i.net_mbf * i.logger_rate.rate
        i.logger_value = i.logger_value.round(2)
      end
      if i.logger_rate.rate_type == "Tonnage"
        i.logger_value = i.tonnage * i.logger_rate.rate
        i.logger_value = i.logger_value.round(2)
      end
      if i.logger_rate.rate_type == "percent"
        i.logger_value = i.value * (i.logger_rate.rate/100)
        i.logger_value = i.logger_value.round(2)
      end
      
      logger_total = logger_total + i.logger_value
    end
    
    total = logger_total
        
    deduction_items.each do |i| 
      total = total - i[1].to_f.round(2)
    end
    
    receipt = Receipt.create(:job_id => job.id, :payment_num => payment_num, :owner_id => logger.id, :owner_type => "logger", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => notes, :total_payment => total)
    tickets.each do |i|
      receipt.tickets.push(i)
      i.paid_to_logger = true
      i.save
    end
    
    unless deduction_items.first.nil?
      deduction_items.each do |i| 
        receipt.receipt_items.create(:item_data => i[0], :value => i[1])
      end
    end
    
    pdf = LoggerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
    send_data pdf.render, filename: "#{job.name}_#{payment_num}_logger_receipt",
                           type: "application/pdf"
  end
  
  #Ajax action
  #Same as above
  def save_trucker_receipt
    tickets = Ticket.find(params[:tickets])
    
    if tickets.first.paid_to_trucker == true
      render :nothing => true, :state => 500
      return
    end
    
    notes = params[:notes]
    job = Job.find(tickets.first.job_id)
    trucker = job.trucker
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("trucker", trucker.id, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    payment_total = 0
    
    tickets.each do |i|
      if i.trucker_rate.rate_type == "MBF"
        payment_total = payment_total + round_to(i.trucker_rate.rate*i.net_mbf, 2)
      else
        if i.trucker_rate.rate_type == "Tonnage"
          payment_total = payment_total + round_to(i.trucker_rate.rate*i.tonnage, 2)
        else
          payment_total = payment_total + round_to(i.trucker_rate.rate/100*i.value, 2)
        end
      end
    end
    
    #Needed by the pdf
    deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        deduction_items.push([i, params[:deductions_values][x]])
      end
    end
    
    deduction_items.each do |i| 
      payment_total - i[1].to_f.round(2)
    end
    
    payment_total = round_to(payment_total, 2)
    
    receipt = Receipt.create(:job_id => job.id, :payment_num => payment_num, :owner_id => trucker.id, :owner_type => "trucker", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => notes, :total_payment => payment_total);
    
    tickets.each do |i|
      receipt.tickets.push(i)
      i.paid_to_trucker = true
      i.save
    end
    
    unless deduction_items.first.nil?
      deduction_items.each do |i| 
        receipt.receipt_items.create(:item_data => i[0], :value => i[1])
      end
    end
    
    pdf = TruckerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
    send_data pdf.render, filename: "#{job.name}_#{payment_num}_trucker_receipt",
                           type: "application/pdf"
  end
  
  #Ajax action
  #Same as above
  def save_hfi_receipt
    tickets = Ticket.find(params[:tickets])
    
    if tickets.first.paid_to_hfi == true
      render :nothing => true, :state => 500
      return
    end
    
    hfi_total = 0
    load_pay_total = 0
    
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    logger = job.logger
    trucker = job.trucker
    
    receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("hfi", 0, job.id, :order => "payment_num")
    unless receipts.first.nil?
      payment_num = receipts.last.payment_num + 1
    else
      payment_num = 1
    end
    
    notes = params[:notes]
    
    tickets.each do |j|
      j.hfi_value = j.value * (job.hfi_rate / 100)
      hfi_total = hfi_total + j.hfi_value.round(2)
      load_pay_total = load_pay_total + j.value
    end
    
    receipt = Receipt.create(:job_id => job.id, :payment_num => payment_num, :owner_id => 0, :owner_type => "hfi", :receipt_date => Time.now.strftime("%Y-%m-%d"), :notes => notes, :total_payment => hfi_total);
    
    tickets.each do |i|
      receipt.tickets.push(i)
      i.paid_to_hfi = true
      i.save
    end
    
    pdf = HFIReceipt.new(tickets, payment_num, notes, view_context)
        send_data pdf.render, filename: "#{job.name}_#{payment_num}_hfi_receipt",
                              type: "application/pdf"
  end
  
  #Ajax action
  #This method was written in case user would be let to delete receipts
  #Not in use at the moment.
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
  
  #Ajax actionm
  #Pulls out from DB the receipt with given id. Rest of the data is associated with that receipt.
  #Sends the corresponding PDF file to user.
  def get_old_receipt
    receipt = Receipt.find(params[:receipt_id])
    job = Job.find(receipt.job_id)
    tickets = receipt.tickets
    payment_num = receipt.payment_num
    
    deduction_items = []
    
    unless receipt.receipt_items.nil?
      receipt.receipt_items.each_with_index do |i|
        deduction_items.push([i.item_data, i.value])
      end     
    end
    
    notes = receipt.notes
    
    if params[:owner_type] == "owner"
      pdf = LandownerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
      send_data pdf.render, filename: "#{job.name}_#{payment_num}_landowner_receipt",
                        type: "application/pdf"
    end
    
    if params[:owner_type] == "logger"
      pdf = LoggerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
      send_data pdf.render, filename: "#{job.name}_#{payment_num}_logger_receipt",
                        type: "application/pdf"
    end
    
    if params[:owner_type] == "trucker"
      pdf = TruckerReceipt.new(tickets, payment_num, deduction_items, notes, view_context)
      send_data pdf.render, filename: "#{job.name}_#{payment_num}_trucker_receipt",
                        type: "application/pdf"
    end
    if params[:owner_type] == "hfi"
      pdf = HFIReceipt.new(tickets, payment_num, notes, view_context)
      send_data pdf.render, filename: "#{job.name}_#{payment_num}_hfi_receipt",
                        type: "application/pdf"
    end
  end
end