class CreateLoggerRates < ActiveRecord::Migration
  def self.up
    create_table :logger_rates do |t|
      t.integer :destination_id
      t.integer :job_id
      t.integer :partner_id
      t.string :load_type
      t.float :rate

      t.timestamps
    end
  end

  def self.down
    drop_table :logger_rates
  end
end
