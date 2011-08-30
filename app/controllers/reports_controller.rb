class ReportsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def quarterly_report
    
  end
  
  def export_database
    
  end
  
  def export_the_thing
    @addresses = Address.all
    @cps = ContactPerson.all
    @destinations = Destination.all
    @jobs = Job.all
    @load_details = LoadDetail.all
    @owners = Owner.all
    @partners = Partner.all
    @payments = PaymentFromDestination.all
    @tickets = Ticket.all
    
    @filu = File.open('addresses_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv', 'w') do |writer|
      writer.puts "id, street, city, zip code, state\n"
      @addresses.each do |i|
        writer.puts "#{i.id}, #{i.street}, #{i.city}, #{i.zip_code}, #{$states[i.state]}\n"
      end
    end
    
       
    #File.open("db_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv", 'w') do |writer|
    #  write.puts()
      
    #end
    
    send_data(@filu, :type => "csv", :filename => "some.csv")
  end
  
end
