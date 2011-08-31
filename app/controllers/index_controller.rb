class IndexController < ApplicationController
  def index
    @job = Job.new()
    @job.logger.name = "Tim"
    
  end

end
