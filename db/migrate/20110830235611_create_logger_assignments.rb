class CreateLoggerAssignments < ActiveRecord::Migration
  def self.up
    create_table :logger_assignments do |t|
      t.integer :job_id
      t.integer :partner_id

      t.timestamps
    end
    
    LoggerAssignment.create(:job_id => 1, :partner_id => 1)
    LoggerAssignment.create(:job_id => 2, :partner_id => 1)
    
  end

  def self.down
    drop_table :logger_assignments
  end
end
