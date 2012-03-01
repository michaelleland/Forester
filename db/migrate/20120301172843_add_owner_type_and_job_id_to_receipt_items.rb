class AddOwnerTypeAndJobIdToReceiptItems < ActiveRecord::Migration
  def self.up
    add_column :receipt_items, :job_id, :integer
    add_column :receipt_items, :owner_type, :string    
  end

  def self.down
  end
end
