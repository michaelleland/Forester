class CreateTicketRanges < ActiveRecord::Migration
  def self.up
    create_table :ticket_ranges do |t|
      t.integer :from
      t.integer :job_id
      t.integer :to

      t.timestamps
    end
    
    TicketRange.create(:from => 1000, :to => 1499, :job_id => 1)
    TicketRange.create(:from => 1500, :to => 1999, :job_id => 2)
    
  end

  def self.down
    drop_table :ticket_ranges
  end
end
