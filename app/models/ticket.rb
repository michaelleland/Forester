class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
  
  def load_details
    @conn = ActiveRecord::Base.connection
    @result = @conn.execute("SELECT * FROM load_details WHERE ticket_id=#{self.id}").collect {|i| i[1] + i[2] + i[3]} 
  end
  
end
