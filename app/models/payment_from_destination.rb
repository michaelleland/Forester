class PaymentFromDestination < ActiveRecord::Base
  has_many :tickets
  
  attr_accessor :destination_id, :total_payment, :net_mbf, :wood_type
  
  def destination_id
    @destination_id = self.tickets.first.destination_id
  end
  
  def total_payment
    @total_payment = 0
    self.tickets.each {|i| @total_payment = @total_payment + i.load_pay }
    @total_payment = (@total_payment*100).round.to_f / 100
  end
  
  def net_mbf
    @net_mbf = 0
    self.tickets.each do |i|
      @net_mbf = @net_mbf + i.net_mbf
    end
    @net_mbf = (@net_mbf*100).round.to_f / 100
  end
  
  def wood_type
    @wood_type = self.tickets.first.wood_type
  end
  
end