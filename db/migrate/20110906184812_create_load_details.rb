class CreateLoadDetails < ActiveRecord::Migration
  def self.up
    create_table :load_details do |t|
      t.integer :ticket_id
      t.integer :species_id
      t.float :tonnage
      t.float :mbfs

      t.timestamps
    end
    
    LoadDetail.create(:ticket_id => 1, :species_id => 1, :mbfs => 9.8)
    LoadDetail.create(:ticket_id => 2, :species_id => 2, :mbfs => 12.3)
    LoadDetail.create(:ticket_id => 3, :species_id => 1, :tonnage => 25.3, :mbfs => 7.4)
    LoadDetail.create(:ticket_id => 4, :species_id => 0, :tonnage => 23.1)
    LoadDetail.create(:ticket_id => 5, :species_id => 0, :tonnage => 28.4)
    LoadDetail.create(:ticket_id => 6, :species_id => 2, :mbfs => 8.6)
    LoadDetail.create(:ticket_id => 7, :species_id => 1, :tonnage => 29.4, :mbfs => 8.5)
    LoadDetail.create(:ticket_id => 8, :species_id => 1, :mbfs => 8.2)
    
  end

  def self.down
    drop_table :load_details
  end
end
