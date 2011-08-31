class Job < ActiveRecord::Base
  has_many :receipts
  has_many :tickets
  
  attr_accessor :logger
  
  def logger
    @logger
  end
  
end
