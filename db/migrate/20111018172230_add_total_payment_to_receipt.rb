class AddTotalPaymentToReceipt < ActiveRecord::Migration
  def self.up
    change_table :receipts do |t|    
      t.float :payment_total    
    end
  end

  def self.down
    change_table :assignments do |t|    
      t.delete :payment_id     
    end
  end
end
