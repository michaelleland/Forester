class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  
  def load_details
    @load_details = LoadDetail.find_all_by_ticket_id(self.id) 
  end
  
end
