class LoggerRate < ActiveRecord::Base
  #Rate type is returned as a formatted string to be shown in receipts ticket tables.
  #This is also because rate type value "Tonnage" would be way too long.
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