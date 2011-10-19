class LoadDetail < ActiveRecord::Base
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
