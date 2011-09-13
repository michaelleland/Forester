class TruckerRates < ActiveRecord::Migration
  def self.up
    create_table :trucker_rates, :id => false do |t|
      t.integer :destination_id, :primary_key
      t.integer :job_id, :primary_key
      t.integer :partner_id, :primary_key
      t.float :rate
    end    
  end

  def self.down
    drop_table :trucker_rates
  end
end
