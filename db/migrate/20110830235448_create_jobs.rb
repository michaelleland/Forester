class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.string :owner_id
      t.float :hfi_rate
      t.boolean :hfi_prime
      t.integer :ticket_range_from
      t.integer :ticket_range_to
      
      t.timestamps
    end
    
    Job.create(:name => "Esteb-Kaski", :owner_id => 1, :hfi_rate => 3.0, :hfi_prime => true, :ticket_range_from => 1000, :ticket_range_to => 1499)
    Job.create(:name => "Joe Rhoades", :owner_id => 2, :hfi_rate => 3.0, :hfi_prime => true, :ticket_range_from => 1500, :ticket_range_to => 1999)
    
  end

  def self.down
    drop_table :jobs
  end
end
