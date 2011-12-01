class AddPaidToHfiToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.boolean :paid_to_hfi
    end
    
    Ticket.update_all ["paid_to_hfi = ?", false]
  end

  def self.down
    change_table :tickets do |t|
      t.delete :paid_to_hfi
    end
  end
end
