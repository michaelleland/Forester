class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def owner_receipt
  end
  
  def add_deduction
    @receipt_item = ReceiptItem.create(:item_data => params[:data], :receipt_id => 0, :value => params[:deduction_amount])
  end
  
  def get_owner_receipt
    @payments = PaymentFromDestination.find(params[:payments])
    
    @job = Job.find(@payments.first.job_id)
    @owner = Owner.find(@job.owner_id)
        
    @total = 0 
    @payments.collect {|i| @total = @total + i.total_payment}
    
    @deduction_items = []
    
    unless params[:deductions_list].nil?
      params[:deductions_list].each_with_index do |i, x|
        @deduction_items.push([i, params[:deductions_values][x]])
      end     
    end
      
    @deduction_items.collect {|i| @total = @total - i[1].to_f }
    
    @total = ((@total * 10**2).round.to_f / 10**2).to_s
    if (@total.length - (@total.index(".")+1)) < 2
      @total = "#{@total}0"
    end 
  end
  
  def logger_receipt
  
  end
  
  def get_logger_receipt
    
  end
  
  def trucker_receipt
    
  end
end
