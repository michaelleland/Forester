class CreateTruckerAssignments < ActiveRecord::Migration
  def self.up
    create_table :trucker_assignments do |t|
      t.integer :job_id
      t.integer :partner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trucker_assignments
  end
end
