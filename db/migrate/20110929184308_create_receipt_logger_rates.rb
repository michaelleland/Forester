class CreateReceiptLoggerRates < ActiveRecord::Migration
  def self.up
    create_table :receipt_logger_rates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :receipt_logger_rates
  end
end
