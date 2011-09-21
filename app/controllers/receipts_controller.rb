class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
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
    @tickets = Ticket.find(params[:tickets])
    
    @job = Job.find(@tickets.first.job_id)
    @owner = @job.owner
    
    unless @job.logger.rate_percent(@job.id).nil?
      @tickets.each do |i|
        i.logger_value = round_to((i.value * (@job.logger.rate_percent / 100)), 2)
        
        i.trucker_value = 0
        i.load_details.each do |j|
          if j.load_type == "Tonnage"
            i.trucker_value = i.trucker_value + (@job.trucker.hauling_rate(@job.id, i.destination_id) * j.tonnage)
          else
            i.trucker_value = i.trucker_value + (@job.trucker.hauling_rate(@job.id, i.destination_id) * j.mbfs)
          end
        end
        
        i.trucker_value = round_to(i.trucker_value, 2)
        
        i.hfi_value = round_to((@job.hfi_rate / 100 * i.value), 2)
                
        i.owner_value = round_to((i.value - i.logger_value - i.trucker_value - i.hfi_value), 2)
      end
    end
    
    unless @job.logger.rate_tonnage(@job.id).nil?
      @tickets.each do |i|
        
        i.logger_value = 0
        i.trucker_value = 0
        i.load_details.each do |j|
          if j.load_type == "Tonnage"
            i.trucker_value = i.trucker_value + (@job.trucker.hauling_rate(@job.id, i.destination_id) * j.tonnage)
          else
            i.trucker_value = i.trucker_value + (@job.trucker.hauling_rate(@job.id, i.destination_id) * j.mbfs)
          end
          i.logger_value = i.logger_value + round_to((j.tonnage * @job.logger.rate_tonnage(@job.id)), 2)
        end
        
        i.hfi_value = round_to((i.value * (@job.hfi_rate / 100)), 2)
      
      end
    end
        
        
    @total = 0 
    @tickets.each {|i| @total = @total + i.value}
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
      
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
    @total = ((@total * 10**2).round.to_f / 10**2).to_s
    if (@total.length - (@total.index(".")+1)) < 2
      @total = "#{@total}0"
    end 
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
