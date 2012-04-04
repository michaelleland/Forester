class AddColumnIsPaidDecutions < ActiveRecord::Migration
  def self.up
    change_table :receipt_items do |t|
      t.boolean :is_deducted , :default=>false
    end
  end
  def self.down
    remove_column  :receipt_items,:is_deducted
  end
end
