class PaymentFromDestination < ActiveRecord::Base
  belongs_to :job
  belongs_to :destination
  
  #In some case, like when adding up, the code won't work if tonnage or mbf is nil
  #And to make the code that adds up short, these methods are here to help.
  #If tonnage or mbf is nil, the method returns 0. 
  def tonnnage
    unless self.tonnage.nil?
      self.tonnage
    else
      0
    end
    
  end
  
  def net_mbff
    if self.net_mbf.nil?
      0
    else
      self.net_mbf
    end
  end
  
  
end
