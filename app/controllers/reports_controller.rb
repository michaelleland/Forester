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
          @amounts[j.species_id-1] = @amounts[j.species_id-1] + j.mbfs
        end
        if i.wood_type == 3 # WoodType with id = 3 is Pulp and it is always last in amounts the list
          @total_pulp = @total_pulp + j.tonnage
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
      @jobs = Job.all
      
      @filename = "Jobs_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Jobs, , , , , Logging rates"
      @table_headers = "Name, Owner Name, Logger Name, Trucker Name, HFI-rate (%), MBF, Tonnage" 
    end
    
    if params[:id] == "2"
      @tickets = Ticket.all
      
      @filename = "Tickets_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Tickets"
      
      @specie_codes = ""
      
      Specie.all.each do |i|
        @specie_codes << "#{i.code}, "
      end
      
      @table_headers = "Number, delivery Date, Destination Name, Job Name, Wood Type, Load Type, #{@specie_codes}Tonnage, Net MBF, Load Pay"      
    end
    if params[:id] == "3"
      @payments = PaymentFromDestination.all
      
      @filename = "Payments_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "shared/system/exports/"
      @table_name = "Payments"
      @table_headers = "Date, Destination Name, Job Name, Payment #, Wood Type, Load Type, Net MBF, Tonnage, Total Payment"      
    end
    
    File.open("#{@file_path}#{@filename}", "w") do |writer|
      writer.puts @table_name
      writer.puts @table_headers
      
      if params[:id] == "1"
        @jobs.each do |i|
          @puts = "#{i.name}, #{i.owner.name}, #{i.logger.name}, #{i.trucker.name}, #{i.hfi_rate}, "
          @puts << "#{i.logger.rate_mbf(i.id)}, #{i.logger.rate_tonnage(i.id)}\n"
          writer.puts @puts
        end
      end
      
      if params[:id] == "2"
        @tickets.each do |i|
          @amounts = []
          
          Specie.all.length.times do 
            @amounts.push(0)
          end
          
          2.times do
            @amounts.push(0)
          end
          
          i.load_details.each do |j|
            if i.wood_type == "Pulp"
              @amounts[-2] = @amounts[-2] + j.tonnage
            else
              unless j.load_type == "Tonnage"
                @amounts[j.species_id-1] = @amounts[j.species_id-1] + j.mbfs
                @amounts[-1] = @amounts[-1] + j.mbfs
              else
                @amounts[-2] = @amounts[-2] + j.tonnage
              end
            end
          end
          
          @amounts_as_string = ""
          
          @amounts.each do |j|
            @amounts_as_string << "#{j}, "
          end
          
          @puts = "#{i.number}, #{i.delivery_date}, #{i.destination.name}, #{i.job.name}, "
          @puts << "#{WoodType.find(i.wood_type).name}, #{i.load_details.first.load_type}, "
          @puts << "#{@amounts_as_string}#{i.value}"
          writer.puts @puts
        end
      end
      if params[:id] == "3"
        @payments.each do |i|
          @puts = "#{i.payment_date}, #{i.destination.name}, #{i.job.name}, #{i.payment_num}, "
          @puts << "#{WoodType.find(i.wood_type).name}, #{i.load_type}, #{i.tonnage}, #{i.net_mbf}, "
          @puts << "#{i.total_payment}"
          writer.puts @puts
        end
      end
    end
    
    @file = File.open("#{@file_path}#{@filename}", "r")
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
end
