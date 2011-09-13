class WoodPerSpeciesPerLoad < ActiveRecord::Migration
  def self.up
    create_table :load_details, :id => false do |t|
      t.integer :ticket_id, :primary_key
      t.integer :species_id, :primary_key
      t.integer :measure_type
      t.float :amount
    end
  end

  def self.down
    drop_table :load_details
  end
end
