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
      @amounts.push([0, 0])
    end
    @total_pulp = 0
    
    @tickets.each do |i|
      i.load_details.each do |j|
        unless i.wood_type == 3 
          unless j.mbfs.nil?
            @amounts[j.species_id-1][0] = @amounts[j.species_id-1][0] + j.mbfs
          end
          unless j.tonnage.nil?
            @amounts[j.species_id-1][1] = @amounts[j.species_id-1][1] + j.tonnage
          end
        end
        if i.wood_type == 3 # WoodType with id = 3 is Pulp and it is always last in amounts the list
          @total_pulp = @total_pulp + j.tonnage
        end
      end
    end
    
    File.open("#{@file_path}#{@filename}", 'w') do |writer|
      writer.puts "Category, MBF, Tonnage\n"
      @species.each do |i|
        writer.puts "#{i.code}, #{give_pennies(@amounts[i.id-1][0].to_f)}, #{give_pennies(@amounts[i.id-1][1].to_f)}\n"
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
      @jobs = Job.all
      
      @filename = "Jobs_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Jobs"
      @table_headers = "Name, Owner Name, Logger Name, Trucker Name, HFI-rate (%), HFI-prime" 
    end
    
    if params[:id] == "2"
      @tickets = Ticket.all
      
      @filename = "Tickets_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Tickets"
      
      @table_headers = "Number, delivery Date, Destination Name, Job Name, Wood Type, Tonnage, Net MBF, Load Pay"      
    end
    if params[:id] == "3"
      @payments = PaymentFromDestination.all
      
      @filename = "Payments_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Payments"
      @table_headers = "Date, Destination Name, Job Name, Payment #, Wood Type, Net MBF, Tonnage, Total Payment"      
    end
    
    File.open("#{@file_path}#{@filename}", "w") do |writer|
      writer.puts @table_name
      writer.puts @table_headers
      
      if params[:id] == "1"
        @jobs.each do |i|
          @puts = "#{i.name}, #{i.owner.name}, #{i.logger.name}, #{i.trucker.name}, #{i.hfi_rate}, #{i.hfi_prime}\n"
          writer.puts @puts
        end
      end
      
      if params[:id] == "2"
        @tickets.each do |i|
          @puts = "#{i.number}, #{i.delivery_date}, #{i.destination.name}, #{i.job.name}, "
          @puts << "#{WoodType.find(i.wood_type).name}, #{i.tonnage}, #{i.net_mbf}, #{give_pennies(i.value)}\n"
          writer.puts @puts
        end
      end
      if params[:id] == "3"
        @payments.each do |i|
          @puts = "#{i.payment_date}, #{i.destination.name}, #{i.job.name}, #{i.payment_num}, "
          @puts << "#{WoodType.find(i.wood_type).name}, #{i.tonnage}, #{i.net_mbf}, "
          @puts << "#{give_pennies(i.total_payment)}"
          writer.puts @puts
        end
      end
    end
    
    @file = File.open("#{@file_path}#{@filename}", "r")
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
end
