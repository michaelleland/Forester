class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
    
    Owner.create(:name => "Orville Esteb", :contact_person_id => 3, :address_id => 3)
    Owner.create(:name => "Joe Rhoades", :contact_person_id => 4, :address_id => 4)
    
  end

  def self.down
    drop_table :owners
  end
end
