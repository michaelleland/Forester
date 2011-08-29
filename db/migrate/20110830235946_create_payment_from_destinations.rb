class CreatePaymentFromDestinations < ActiveRecord::Migration
  def self.up
    create_table :payment_from_destinations do |t|
      t.integer :job_id
      t.string :load_type
      t.date :payment_date
      t.string :payment_num
      t.float :tonnage
      t.boolean :paid_to_owner
      t.boolean :paid_to_logger
      t.boolean :paid_to_trucker

      t.timestamps
    end
    
    PaymentFromDestination.create(:job_id => 1, :wood_type => 1,:load_type => "MBF", :payment_date => "15-09-2011", :payment_num => "1231421", :total_payment => 9703.5, :paid_to_owner => true, :paid_to_logger => false, :paid_to_trucker => false)
    PaymentFromDestination.create(:job_id => 1, :wood_type => 2, :load_type => "MBF", :payment_date => "23-09-2011", :payment_num => "1231425", :total_payment => 5402.3, :paid_to_owner => false, :paid_to_logger => false, :paid_to_trucker => false)
    PaymentFromDestination.create(:job_id => 1, :wood_type => 3, :load_type => "MBF", :payment_date => "30-09-2011", :payment_num => "1231455", :total_payment => 13023.1, :paid_to_owner => false, :paid_to_logger => false, :paid_to_trucker => false)
    PaymentFromDestination.create(:job_id => 2, :wood_type => 2, :load_type => "MBF", :payment_date => "15-09-2011", :payment_num => "1231422", :total_payment => 9522.7, :paid_to_owner => true, :paid_to_logger => false, :paid_to_trucker => false)
  
  end

  def self.down
    drop_table :payment_from_destinations
  end
end
