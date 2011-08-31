class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
    
    Destination.create(:name => "Pacific Fibre")
    Destination.create(:name => "Weyco Hardwood")
    
  end

  def self.down
    drop_table :destinations
  end
end
