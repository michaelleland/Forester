class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.string :owner_id
      t.float :hfi_rate
      t.boolean :hfi_prime

      t.timestamps
    end
    
    Job.create(:name => "Esteb-Kaski", :owner_id => 1, :hfi_rate => 3.0, :hfi_prime => true)
    Job.create(:name => "Joe Rhoades", :owner_id => 2, :hfi_rate => 3.0, :hfi_prime => true)
    
  end

  def self.down
    drop_table :jobs
  end
end
