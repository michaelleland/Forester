class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.date :delivery_date
      t.integer :destination_id
      t.integer :job_id
      t.integer :number
      t.integer :wood_type
      t.boolean :paid_to_owner
      t.boolean :paid_to_logger
      t.boolean :paid_to_trucker
      t.float :value
      
      t.timestamps
    end
    
    Ticket.create(:delivery_date => "2011-09-12", :destination_id => 1, :job_id => 1, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2435, :wood_type => 1, :value => 2314.94) 
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 2, :job_id => 1, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2437, :wood_type => 2, :value => 2003.45)
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 1, :job_id => 2, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2901, :wood_type => 2, :value => 1920.65)
    Ticket.create(:delivery_date => "2011-09-15", :destination_id => 2, :job_id => 2, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2905, :wood_type => 3, :value => 2304.54)
    Ticket.create(:delivery_date => "2011-09-12", :destination_id => 1, :job_id => 2, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2906, :wood_type => 3, :value => 3240.88)
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 2, :job_id => 1, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2438, :wood_type => 2, :value => 2976.12)
    Ticket.create(:delivery_date => "2011-09-16", :destination_id => 1, :job_id => 1, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2439, :wood_type => 1, :value => 2532.54)
    Ticket.create(:delivery_date => "2011-09-11", :destination_id => 2, :job_id => 2, :paid_to_logger => false, :paid_to_owner => false, :paid_to_trucker => false, :number => 2907, :wood_type => 1, :value => 2109.94)
    
  end

  def self.down
    drop_table :tickets
  end
end
