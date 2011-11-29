class FloatsToDecimals < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.rename :value, :float_value
      t.decimal :value, :precision => 8, :scale => 2
    end
    
    Ticket.all.each do |i|
      i.value = i.float_value.to_s
      i.save 
    end
    
    remove_column :tickets, :float_value
    
    change_table :payment_from_destinations do |t|
      t.rename :total_payment, :float_value
      t.decimal :total_payment, :precision => 8, :scale => 2
    end
    
    PaymentFromDestination.all.each do |i|
      i.total_payment = i.float_value.to_s
      i.save 
    end
    
    remove_column :payment_from_destinations, :float_value
    
    change_table :receipts do |t|
      t.rename :payment_total, :float_value
      t.decimal :total_payment, :precision => 8, :scale => 2
    end
    
    Receipt.all.each do |i|
      i.total_payment = i.float_value.to_s
      i.save 
    end
    
    remove_column :receipts, :float_value
    
    change_table :logger_rates do |t|
      t.rename :rate, :float_value
      t.decimal :rate, :precision => 8, :scale => 2
    end
    
    LoggerRate.all.each do |i|
      i.rate = i.float_value.to_s
      i.save 
    end
    
    remove_column :logger_rates, :float_value
    
    change_table :trucker_rates do |t|
      t.rename :rate, :float_value
      t.decimal :rate, :precision => 8, :scale => 2
    end
    
    TruckerRate.all.each do |i|
      i.rate = i.float_value
      i.save 
    end
    
    remove_column :trucker_rates, :float_value
    
    change_table :receipt_items do |t|
      t.rename :value, :float_value
      t.decimal :value, :precision => 8, :scale => 2
    end
    
    ReceiptItem.all.each do |i|
      i.value = i.float_value
      i.save 
    end
    
    remove_column :receipt_items, :float_value
    
    
  end
  
  def self.down
  end
end
