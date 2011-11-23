class LoggerRate < ActiveRecord::Base
  def rate_typee
    if self.rate_type == "MBF"
      "/ MBF"
    else 
      if self.rate_type == "Tonnage"
        "/ TON"
      else
        " %"
      end
    end
  end
end