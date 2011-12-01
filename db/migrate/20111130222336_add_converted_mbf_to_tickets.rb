class AddConvertedMbfToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.boolean :mbf_converted
    end
    
    Ticket.update_all ["mbf_converted = ?", false]
    
  end

  def self.down
    change_table :tickets do |t|
      t.delete :mbf_converted
    end
  end
end
