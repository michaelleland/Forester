class WoodPerSpeciesPerLoad < ActiveRecord::Migration
  def self.up
    create_table :load_details do |t|
      t.integer :ticket_id
      t.integer :species_id
      t.integer :measure_type
      t.float :amount
    end
  end

  def self.down
    drop_table :load_details
  end
end
