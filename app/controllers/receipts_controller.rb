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
    @time = Time.now
    
    @tickets = Ticket.find(params[:tickets])
    
    @job = Job.find(@tickets.first.job_id)
    @owner = @job.owner
    
    #@receipts = Receipt.find_all_by_owner_type_and_owner_id_and_job_id("owner", @owner.id, @job.id, :order => "payment_num")
    #@next_num = @receipts.last.payment_num + 1
    @next_num = 2
    
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    @tickets.each do |j|
      @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
      if j.load_type == "MBF"
        j.trucker_value = @rate.rate * j.net_mbf
      else
        if j.load_type == "Tonnage"
          j.trucker_value = @rate.rate * j.tonnage
        end
      end
      
      j.hfi_value = j.value * (@job.hfi_rate / 100)
      
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
      j.owner_value = j.value - j.logger_value - j.trucker_value - j.hfi_value
    end
    
    @total = 0
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
    @job = Job.find(params[:job_id])
    @tickets = Ticket.find(params[:tickets])
    @total = 0
    @tickets.each {|i| @total = @total + i.value }
    @total = (@total*100).round.to_f / 100
  end
  
  def trucker_receipt
    
  end
end
