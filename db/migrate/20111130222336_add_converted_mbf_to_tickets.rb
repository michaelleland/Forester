class AddConvertedMbfToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.boolean :mbf_converted
    end
  end

  def self.down
    change_table :tickets do |t|
      t.delete :mbf_converted
    end
  end
end
