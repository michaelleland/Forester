class Ticket < ActiveRecord::Base
  belongs_to :payment_from_destination
  
  belongs_to :job
  
  def load_details
    @load_details = LoadDetail.find_all_by_ticket_id(self.id) 
  end
  
  def net_mbf
    @net_mbf = 0
    self.load_details.each do |i|
      @net_mbf = @net_mbf + i.amount
    end
    @net_mbf = (@net_mbf*100).round.to_f / 100
  end
  
end
