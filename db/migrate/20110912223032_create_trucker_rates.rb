class CreateTruckerRates < ActiveRecord::Migration
  def self.up
    create_table :trucker_rates do |t|
      t.integer :destination_id
      t.integer :job_id
      t.integer :partner_id
      t.string :load_type
      t.float :rate
      t.timestamps
    end
    
    TruckerRate.create(:destination_id => 1, :job_id => 1, :partner_id => 2, :load_type => "Ton", :rate => 203.50)
    TruckerRate.create(:destination_id => 2, :job_id => 2, :partner_id => 2, :load_type => "Ton", :rate => 199.75)
    
  end

  def self.down
    drop_table :trucker_rates
  end
end
