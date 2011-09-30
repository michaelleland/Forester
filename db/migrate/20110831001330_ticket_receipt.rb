class TicketReceipt < ActiveRecord::Migration
  def self.up
    create_table :receipts_tickets, :id => false do |t|
      t.integer :receipt_id
      t.integer :ticket_id
    end
  end

  def self.down
    drop_table :receipts_tickets
  end
end
