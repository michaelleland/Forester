class ReceiptsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def owner_receipt
    @uniques = ReceiptItem.all.collect {|i| i.item_data }.uniq
    @uniques_ids = []
    ReceiptItem.all.each do |i|
      @uniques.each do |j|
        if i.item_data == j
          @uniques_ids.push(i.id)
        end
      end
    end
    
    @receipt_items = ReceiptItem.find(@uniques_ids)
    
  end
  
  def get_owner_receipt
    @job = Job.find(params[:job_id])
    @owner = Owner.find(params[:owner_id])
    @receipt = Receipt.find_by_job_id_and_owner_id(@job.id, @owner_id)
    @payments = PaymentFromDestination.find_all_by_job_id(@job.id)
    
    @total = 0 
    @payments.collect {|i| @total = @total + i.total_payment}
    
  end
  
  def add_deduction
    
  end
  
  def logger_receipt
  
  end
  
  def trucker_receipt
    
  end
end
