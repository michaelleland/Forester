class CreateContactPeople < ActiveRecord::Migration
  def self.up
    create_table :contact_people do |t|
      t.string :name
      t.string :phone_number
      t.string :email

      t.timestamps
    end
    
    ContactPerson.create(:name => "Mikko Levanen", :phone_number => "360-408-3420", :email => "mikko@levanenlogging.com")
    ContactPerson.create(:name => "Tero Tapani", :phone_number => "360-433-2043", :email => "tero@tapanitrucking.com")
    
  end

  def self.down
    drop_table :contact_people
  end
end
