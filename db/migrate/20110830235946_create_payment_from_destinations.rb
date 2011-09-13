class CreatePaymentFromDestinations < ActiveRecord::Migration
  def self.up
    create_table :payment_from_destinations do |t|
      t.integer :destination_id
      t.integer :job_id
      t.date :payment_date
      t.integer :payment_no
      t.integer :tickets
      t.float :gross 

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_from_destinations
  end
end
