class CreateTruckerRates < ActiveRecord::Migration
  def self.up
    create_table :trucker_rates do |t|
      t.integer :destination_id
      t.integer :job_id
      t.integer :partner_id
      t.float :rate
      t.timestamps
    end
  end

  def self.down
    drop_table :trucker_rates
  end
end
