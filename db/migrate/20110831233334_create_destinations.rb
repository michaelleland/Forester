class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
    
    Destination.create(:name => "Pacific Fibre", :contact_person_id => 5, :address_id => 5)
    Destination.create(:name => "Weyco Hardwood", :contact_person_id => 6, :address_id => 6)
    
  end

  def self.down
    drop_table :destinations
  end
end
