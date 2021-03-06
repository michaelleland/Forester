class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :zip_code
      t.integer :state

      t.timestamps
    end
    
    Address.create(:street => "202 SW 10th Ave", :city => "Vancouver", :zip_code => "98545", :state => 47)
    Address.create(:street => "1 SE Tapani Rd", :city => "Battle Ground", :zip_code => "98604", :state => 47)
    Address.create(:street => "34 SW Estebstate Rd", :city => "Battle Ground", :zip_code => "98604", :state => 47)
    Address.create(:street => "52 NE Jussi Rhd", :city => "Battle Ground", :zip_code => "98604", :state => 47)
    Address.create(:street => "20 NW Sawwy Ave", :city => "Yacolt", :zip_code => "98605", :state => 47)
    Address.create(:street => "96 NE Massive Blast Formation Ave", :city => "Battle Ground", :zip_code => "98604", :state => 47)
    
  end

  def self.down
    drop_table :addresses
  end
end
