class CreateReceiptItems < ActiveRecord::Migration
  def self.up
    create_table :receipt_items do |t|
      t.string :item_data
      t.integer :receipt_id
      t.float :value

      t.timestamps
    end
  end

  def self.down
    drop_table :receipt_items
  end
end
