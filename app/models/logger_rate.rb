class LoggerRate < ActiveRecord::Base
  def rate_typee
    if self.rate_type == "MBF"
      "MBF"
    else
      "TON"
    end
  end
end
