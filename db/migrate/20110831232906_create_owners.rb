class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
    
    Owner.create(:name => "Orville Esteb")
    Owner.create(:name => "Joe Rhoades")
    
  end

  def self.down
    drop_table :owners
  end
end
