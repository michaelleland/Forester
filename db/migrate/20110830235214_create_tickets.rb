class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.date :date
      t.integer :destination_id
      t.integer :job_id
      t.integer :number
      t.float :value

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
