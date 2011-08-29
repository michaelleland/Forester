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
    @job = Job.find(params[:job_id])
    @owner = Owner.find(params[:owner_id])
    @receipt = Receipt.find_by_job_id_and_owner_id(@job.id, @owner_id)
    
    @payments = PaymentFromDestination.find(params[:payments])
    
    @total = 0 
    @payments.collect {|i| @total = @total + i.total_payment}
    
    @deduction_items = []
    
    params[:deductions_list].each_with_index do |i, x|
      @deduction_items.push([i, params[:deductions_values][x]])
    end
    
    @deduction_items.collect {|i| @total = @total - i[1].to_f }
    
  end
  
  def logger_receipt
  
  end
  
  def trucker_receipt
    
  end
end
