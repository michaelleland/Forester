class CreatePartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
    
    Partner.create(:name => "Levanen Inc", :contact_person_id => 1, :address_id => 1)
    Partner.create(:name => "Tapani Trucking", :contact_person_id => 1, :address_id => 2)
    
  end

  def self.down
    drop_table :partners
  end
end
