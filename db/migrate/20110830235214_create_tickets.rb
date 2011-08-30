class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.date :date
      t.integer :destination_id
      t.integer :job_id
      t.integer :number
      t.float :value
      t.boolean :paid_to_owner
      t.boolean :paid_to_logger
      t.boolean :paid_to_trucker
      t.integer :wood_type

      t.timestamps
    end
    
    Ticket.create(:date => "2011-09-12", :destination_id => 1, :job_id => 1, :number => 2435, :value => 2315.34, :paid_to_logger => false, :paid_to_trucker => false, :paid_to_owner => false, :wood_type => 1)
    Ticket.create(:date => "2011-09-13", :destination_id => 1, :job_id => 1, :number => 2437, :value => 2103.43, :paid_to_logger => false, :paid_to_trucker => false, :paid_to_owner => false, :wood_type => 2)
    Ticket.create(:date => "2011-09-13", :destination_id => 2, :job_id => 2, :number => 2901, :value => 1915.34, :paid_to_logger => false, :paid_to_trucker => false, :paid_to_owner => false, :wood_type => 1)
    Ticket.create(:date => "2011-09-15", :destination_id => 1, :job_id => 2, :number => 2905, :value => 2300.45, :paid_to_logger => false, :paid_to_trucker => false, :paid_to_owner => false, :wood_type => 3)
    
  end

  def self.down
    drop_table :tickets
  end
end
