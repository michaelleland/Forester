class ReportsController < ApplicationController
  layout "left_nav", :except => [:printable_owner_receipt]
  
  def owner_receipt
  end
  
  def printable_owner_receipt
    render :layout => "printable_owner_receipt"  
  end
  
  def logger_receipt
  end

end
