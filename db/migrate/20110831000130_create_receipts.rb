class CreateReceipts < ActiveRecord::Migration
  def self.up
    create_table :receipts do |t|
      t.integer :job_id
      t.integer :logger_id
      t.integer :owner_id
      t.string :owner_type
      t.date :receipt_date

      t.timestamps
    end
  end

  def self.down
    drop_table :receipts
  end
end
