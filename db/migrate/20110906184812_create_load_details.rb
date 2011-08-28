class CreateLoadDetails < ActiveRecord::Migration
  def self.up
    create_table :load_details do |t|
      t.integer :ticked_id
      t.integer :species_id
      t.integer :wood_type
      t.integer :measure_type
      t.float :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :load_details
  end
end
