class CreatePaymentFromDestinations < ActiveRecord::Migration
  def self.up
    create_table :payment_from_destinations do |t|
      t.integer :destination_id
      t.integer :job_id
      t.string :load_type
      t.date :payment_date
      t.string :payment_no
      t.integer :tickets
      t.float :total_payment
      t.float :net_mbf
      t.float :tonnage
      t.integer :wood_type

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_from_destinations
  end
end
