class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.string :owner_id
      t.float :hfi_rate
      t.boolean :hfi_prime

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
