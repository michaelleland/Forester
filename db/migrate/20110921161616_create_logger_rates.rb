class CreateLoggerRates < ActiveRecord::Migration
  def self.up
    create_table :logger_rates do |t|
      t.integer :destination_id
      t.integer :job_id
      t.integer :partner_id
      t.float :rate
      t.string :rate_type

      t.timestamps
    end
    
    LoggerRate.create(:destination_id => 1, :job_id => 1, :partner_id => 1, :rate => 45.0, :rate_type => "Tonnage")
    LoggerRate.create(:destination_id => 1, :job_id => 2, :partner_id => 1, :rate => 43.0, :rate_type => "Tonnage")
    LoggerRate.create(:destination_id => 2, :job_id => 1, :partner_id => 1, :rate => 180.0, :rate_type => "MBF")
    LoggerRate.create(:destination_id => 2, :job_id => 2, :partner_id => 1, :rate => 195.0, :rate_type => "MBF")
    
  end

  def self.down
    drop_table :logger_rates
  end
end
