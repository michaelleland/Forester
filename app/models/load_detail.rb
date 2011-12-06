class LoadDetail < ActiveRecord::Base
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
  
  def mbfss
    unless mbfs.nil?
      self.mbfs
    else
      0
    end
  end
  
end
