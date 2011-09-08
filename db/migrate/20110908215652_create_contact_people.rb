class CreateContactPeople < ActiveRecord::Migration
  def self.up
    create_table :contact_people do |t|
      t.string :name
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_people
  end
end
