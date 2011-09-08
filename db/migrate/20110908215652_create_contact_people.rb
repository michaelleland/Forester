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
    ContactPerson.create(:name => "Orville Esteb", :phone_number => "360-365-3443", :email => "steborville@gmail.com")
    ContactPerson.create(:name => "Joe Rhoades", :phone_number => "360-903-9686", :email => "joe.rhoades@gmail.com")
    ContactPerson.create(:name => "Tom Sawyer", :phone_number => "360-866-7299", :email => "tom@pacificfibre.com")
    ContactPerson.create(:name => "Maw Sill", :phone_number => "360-629-7455", :email => "maw.sill@weycohw.com")    
  end

  def self.down
    drop_table :contact_people
  end
end
