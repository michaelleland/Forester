class CreatePaymentFromDestinations < ActiveRecord::Migration
  def self.up
    create_table :payment_from_destinations do |t|
      t.integer :destination_id
      t.integer :job_id
      t.string :load_type
      t.date :payment_date
      t.string :payment_num
      t.float :tonnage
      t.integer :tickets
      t.float :total_payment
      t.float :net_mbf
      t.float :tonnage
      t.integer :wood_type
      
      t.timestamps
    end
    
    PaymentFromDestination.create(:destination_id => 1, :job_id => 1, :wood_type => 1,:load_type => "MBF", :payment_date => "15-09-2011", :payment_num => "1231421", :tickets => 3, :total_payment => 9703.5, :net_mbf => 78.9)
    PaymentFromDestination.create(:destination_id => 2, :job_id => 1, :wood_type => 2, :load_type => "MBF", :payment_date => "23-09-2011", :payment_num => "1231425", :tickets => 2, :total_payment => 5402.3, :net_mbf => 55.3)
    PaymentFromDestination.create(:destination_id => 2, :job_id => 1, :wood_type => 3, :load_type => "MBF", :payment_date => "30-09-2011", :payment_num => "1231455", :tickets => 5, :total_payment => 13023.1, :net_mbf => 100.1)
    PaymentFromDestination.create(:destination_id => 1, :job_id => 2, :wood_type => 2, :load_type => "MBF", :payment_date => "15-09-2011", :payment_num => "1231422", :tickets => 3, :total_payment => 9522.7, :net_mbf => 77.7)
  
  end

  def self.down
    drop_table :payment_from_destinations
  end
end
