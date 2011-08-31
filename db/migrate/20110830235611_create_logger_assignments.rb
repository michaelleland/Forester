class CreateLoggerAssignments < ActiveRecord::Migration
  def self.up
    create_table :logger_assignments do |t|
      t.integer :job_id
      t.integer :partner_id
      t.float :rate_mbf
      t.float :rate_percent
      t.float :rate_tonnage

      t.timestamps
    end
  end

  def self.down
    drop_table :logger_assignments
  end
end
