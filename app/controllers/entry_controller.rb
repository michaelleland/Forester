class EntryController < ApplicationController
  layout false
  
  def entry
    @job = Job.new()
    @job.logger = WoodLogger.new
    @job.logger.name = "Tim"
  end
  
  def add_entry_row
    
  end
  
end
