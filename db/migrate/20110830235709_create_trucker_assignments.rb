class CreateTruckerAssignments < ActiveRecord::Migration
  def self.up
    create_table :trucker_assignments do |t|
      t.integer :job_id
      t.integer :partner_id

      t.timestamps
    end
    
    TruckerAssignment.create(:job_id => 1, :partner_id => 2)
    TruckerAssignment.create(:job_id => 2, :partner_id => 2)
    
  end

  def self.down
    drop_table :trucker_assignments
  end
end
