class CreateTruckerRates < ActiveRecord::Migration
  def self.up
    create_table :trucker_rates do |t|
      t.integer :destination_id
      t.integer :job_id
      t.integer :partner_id
      t.float :rate
      t.string :rate_type
      
      t.timestamps
    end
    
    TruckerRate.create(:destination_id => 1, :job_id => 1, :partner_id => 2, :rate => 28.2, :rate_type => "Tonnage")
    TruckerRate.create(:destination_id => 1, :job_id => 2, :partner_id => 2, :rate => 22.0, :rate_type => "Tonnage")
    TruckerRate.create(:destination_id => 2, :job_id => 1, :partner_id => 2, :rate => 23.4, :rate_type => "Tonnage")
    TruckerRate.create(:destination_id => 2, :job_id => 2, :partner_id => 2, :rate => 21.6, :rate_type => "Tonnage")
    
  end

  def self.down
    drop_table :trucker_rates
  end
end
