class CreateLoadDetails < ActiveRecord::Migration
  def self.up
    create_table :load_details do |t|
      t.integer :ticket_id
      t.integer :species_id
      t.string :load_type
      t.float :amount

      t.timestamps
    end
    
    LoadDetail.create(:ticket_id => 1, :species_id => 1, :load_type => "MBF", :amount => 9.8)
    LoadDetail.create(:ticket_id => 2, :species_id => 2, :load_type => "MBF", :amount => 12.3)
    LoadDetail.create(:ticket_id => 3, :species_id => 1, :load_type => "Tonnage", :amount => 25.3)
    LoadDetail.create(:ticket_id => 4, :species_id => 4, :load_type => "MBF", :amount => 7.4)
    
  end

  def self.down
    drop_table :load_details
  end
end
