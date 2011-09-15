class CreateReceiptItems < ActiveRecord::Migration
  def self.up
    create_table :receipt_items do |t|
      t.string :item_data
      t.integer :receipt_id
      t.float :value

      t.timestamps
    end
    
    ReceiptItem.create(:item_data => "Culvert", :receipt_id => 1, :value => 462.23)
    ReceiptItem.create(:item_data => "Gate", :receipt_id => 1, :value => 462.23)
    ReceiptItem.create(:item_data => "Road work", :receipt_id => 1, :value => 2)
    ReceiptItem.create(:item_data => "Road work", :receipt_id => 2, :value => 2803.50)
  end

  def self.down
    drop_table :receipt_items
  end
end
