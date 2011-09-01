class EntryController < ApplicationController
  layout false
  
  def entry
    @jobs = Job.all
    @loggers = Job.all.collect {|i| i.logger }.flatten.uniq
    @destinations = Destination.all
  end
  
  def add_entry_row
    
  end
end
