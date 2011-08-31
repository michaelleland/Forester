class CreatePartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end
end
