class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.date :delivery_date
      t.integer :destination_id
      t.integer :job_id
      t.float :load_pay
      t.integer :number
      t.integer :payment_from_destination_id
      t.integer :wood_type
      t.timestamps
    end
    
    Ticket.create(:delivery_date => "2011-09-12", :destination_id => 1, :job_id => 1, :payment_from_destination_id => 1, :number => 2435, :load_pay => 2315.34, :wood_type => 1) 
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 2, :job_id => 1, :payment_from_destination_id => 2, :number => 2437, :load_pay => 2103.43, :wood_type => 2)
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 1, :job_id => 2, :payment_from_destination_id => 3, :number => 2901, :load_pay => 1915.34, :wood_type => 2)
    Ticket.create(:delivery_date => "2011-09-15", :destination_id => 2, :job_id => 2, :payment_from_destination_id => 4, :number => 2905, :load_pay => 1785.98, :wood_type => 3)
    Ticket.create(:delivery_date => "2011-09-12", :destination_id => 1, :job_id => 2, :payment_from_destination_id => 1, :number => 2906, :load_pay => 3425.87, :wood_type => 3)
    Ticket.create(:delivery_date => "2011-09-13", :destination_id => 2, :job_id => 1, :payment_from_destination_id => 2, :number => 2438, :load_pay => 1829.76, :wood_type => 2)
    Ticket.create(:delivery_date => "2011-09-16", :destination_id => 1, :job_id => 1, :payment_from_destination_id => 3, :number => 2439, :load_pay => 2435.65, :wood_type => 1)
    Ticket.create(:delivery_date => "2011-09-11", :destination_id => 2, :job_id => 2, :payment_from_destination_id => 4, :number => 2907, :load_pay => 2430.54, :wood_type => 1)
    
  end

  def self.down
    drop_table :tickets
  end
end
