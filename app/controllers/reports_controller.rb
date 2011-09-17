class ReportsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def quarterly_report
    
  end
  
  def exported_report
    @filename = "quarterly_report_#{params[:year]}_#{params[:quarter]}.csv"
    @file_path = "shared/system/exports/"
    if params[:quarter] == "1"
      @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{(params[:year].to_i-1).to_s}-12-31' AND delivery_date<'#{params[:year]}-04-01'")
    else
      if params[:quarter] == "2"
       @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-03-31' AND delivery_date<'#{params[:year]}-07-01'")
      else
        if params[:quarter] == "3"
          @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-06-30' AND delivery_date<'#{params[:year]}-10-01'")
        else
          if params[:quarter] == "4" then
            @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-09-30' AND delivery_date<'#{(params[:year].to_i+1).to_s}-01-01'")
          end
        end
      end
    end
    
    @species = Specie.all
    @amounts = []
    
    @species.length.times do
      @amounts.push(0)
    end
    @total_pulp = 0
    
    @tickets.each do |i|
      i.load_details.each do |j|
        unless i.wood_type == 3 
          @amounts[j.species_id-1] = @amounts[j.species_id-1] + j.amount
        end
        if i.wood_type == 3 # WoodType with id = 3 is Pulp and it is always last in amounts the list
          @total_pulp = @total_pulp + j.amount
        end
      end
    end
    
    File.open("#{@file_path}#{@filename}", 'w') do |writer|
      writer.puts "Category, MBF, Tonnage\n"
      @species.each do |i|
        writer.puts "#{i.code}, #{@amounts[i.id-1]}, 0\n"
      end
      writer.puts "Pulp, ,#{@total_pulp}"
    end
    
    @file = File.open("#{@file_path}#{@filename}", 'r')
    
    send_data(@file.read, :type => "csv", :filename => @file_name)
    
  end
  
  def export_database

  end
  
  def export_the_thing
    if params[:id] == "1"
      @filename = "Jobs_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/#{@filename}"
      
    end
    if params[:id] == "2"
      @filename = "Tickets_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/#{@filename}"
      
    end
    if params[:id] == "3"
      @filename = "Payments_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/#{@filename}"
      
    end
    
    File.open("#{@file_path}#{@filename}", "w") do |writer|
      
      writer.puts @table_name
      writer.puts @table_headers
      if params[:id] == "1"
        @jobs.each do |i|
          writer.puts "#{i.name}, #{i.owner.name}, #{i.logger.name}, #{i.trucker.name}, #{i.hfi_rate}, #{i.logger.tonnage_rate}, #{i.logger.mbf_rate}, #{i.trucker.rate_mbf}, #{i.trucker.rate_tonnage}, #{i.trucker.rate_percent}"
        end
      end
      if params[:id] == "2"
          
      end
      if params[:id] == "3"
          
      end
      
      writer.puts "\n"
      
      writer.puts "Contact people"
      writer.puts "id, Name, Phone Number, E-mail\n"
      @contact_people.each do |i|
        writer.puts "#{i.id}, \"#{i.name}\", #{i.phone_number}, #{i.email}\n"
      end
      
      writer.puts "\n"
      
      writer.puts "Jobs"
      writer.puts "id, Name, Owner, HFI Rate, HFI Prime\n"
      @jobs.each do |i|
        writer.puts "#{i.id}, \"#{i.name}\", #{Owner.find(i.owner_id).name}, #{i.hfi_rate}, #{i.hfi_prime}\n"
      end
      
      writer.puts "\n"
      
      writer.puts "Truckers & Loggers"
      writer.puts "id, Name, Address id, Contact Person id\n"
      @partners.each do |i|
        writer.puts "#{i.id}, \"#{i.name}\", #{i.address_id}, #{i.contact_person_id}\n"
      end
      
      writer.puts "\n"
      
      writer.puts "Tickets"
      writer.puts "id, Number, Delivery Date, Destination, Job Name, Wood Type, Load Type, Load Pay\n"
      @tickets.each do |i|
        writer.puts "#{i.id}, #{i.number}, #{i.delivery_date}, #{Destination.find(i.destination_id).name}, #{Job.find(i.job_id).name}, #{WoodType.find(i.wood_type).name}, #{i.load_details.first.load_type}, #{i.value}\n"
      end
      
      writer.puts "\n"
      
      writer.puts "Payments"
      writer.puts "id, Destination, Job Name, Wood Type, Load Type, Payment #, Number of tickets, Net MBF, Total Payment\n"
      @payments.each do |i|
        writer.puts "#{i.id}, #{i.payment_date}, #{Destination.find(i.destination_id).name}, #{Job.find(i.job_id).name}, #{WoodType.find(i.wood_type).name}, #{i.load_type}, #{i.payment_num}, #{i.tickets}, #{i.net_mbf}, #{i.total_payment}\n"
      end
      
      writer.puts "\n"
      
      writer.puts "Owners" 
      writer.puts "id, name, address id, contact person id\n"
      @owners.each do |i|
        writer.puts "#{i.id}, #{i.name}, #{i.address_id}, #{i.contact_person_id}\n"
      end
      
    end
    
    @file = File.open("#{@file_path}#{@filename}", "r")
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
end
