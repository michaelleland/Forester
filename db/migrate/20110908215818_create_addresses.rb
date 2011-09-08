class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :zip_code
      t.integer :state

      t.timestamps
    end
    
    Address.create(:street => "202 SW 10th Avenue", :city => "Vancouver", :zip_code => "98545", :state => 48)
    Address.create(:street => "1 Tapani Rd", :city => "Battle Ground", :zip_code => "98604", :state => 48)
    Address.create(:street => "34 SW Estebstate Rd", :city => "Battle Ground", :zip_code => "98604", :state => 48)
    Address.create(:street => "52 NE Jussi Rhd", :city => "Battle Ground", :zip_code => "98604", :state => 48)
    
  end

  def self.down
    drop_table :addresses
  end
end
