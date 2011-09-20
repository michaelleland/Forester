class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    
    Specie.create(:name => "Douglas Fir", :code => "DF")
    Specie.create(:name => "Hemlock", :code => "WH")
    Specie.create(:name => "Cedar", :code => "RC")
    Specie.create(:name => "Alder", :code => "RA")
    Specie.create(:name => "Maple", :code => "OH")
    
  end

  def self.down
    drop_table :species
  end
end
