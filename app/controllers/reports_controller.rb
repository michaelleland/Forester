class ReportsController < ApplicationController
  layout nil
  
  def owner_receipt
  end
  
  def printable_owner_receipt
    render :layout => "printable_owner_receipt"  
  end
  
  def logger_receipt
  end
  
  def index
    render :layout => "left_nav"
  end

end
