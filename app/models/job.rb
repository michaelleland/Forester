class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  
  def logger
    @logger = Logger.new()
  end
  
end
