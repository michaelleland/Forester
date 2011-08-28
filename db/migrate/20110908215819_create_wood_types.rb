class CreateWoodTypes < ActiveRecord::Migration
  def self.up
    create_table :wood_types do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    
    WoodType.create(:name => "Sawlogs")
    WoodType.create(:name => "Export")
    WoodType.create(:name => "Pulp")
    WoodType.create(:name => "Mixed")
    WoodType.create(:name => "Specialty")
    WoodType.create(:name => "Habitat Logs")
    
  end

  def self.down
    drop_table :wood_types
  end
end
