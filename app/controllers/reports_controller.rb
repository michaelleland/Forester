class ReportsController < ApplicationController
  layout nil
  
  #Show action
  def index
    
  end
  
  #Show action
  def quarterly_report
    
  end
  
  #Ajax action
  #Gathers ticket from given quarter of given year and produces a report from them.
  #In the report the gathered mbf and tonnage information from tickets is broken down by job.
  def exported_report
    #The folder where the filename points to, is actually in the ~/rails/Forester because of capistrano as
    # the Apache point to ~/rails/Forester/current symlinkfolder and capistrano updates the them.  
    @filename = "quarterly_report_#{params[:year]}_#{params[:quarter]}.csv"
    @file_path = "#{Rails.root}/../../shared/system/exports/"
    if params[:quarter] == "1"
      @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{(params[:year].to_i-1)}-12-31' AND delivery_date<'#{params[:year]}-04-01'")
    else
      if params[:quarter] == "2"
       @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-03-31' AND delivery_date<'#{params[:year]}-07-01'")
      else
        if params[:quarter] == "3"
          @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-06-30' AND delivery_date<'#{params[:year]}-10-01'")
        else
          if params[:quarter] == "4" then
            @tickets = Ticket.find(:all, :conditions => "delivery_date>'#{params[:year]}-09-30' AND delivery_date<'#{(params[:year].to_i+1)}-01-01'")
          end
        end
      end
    end
    
    #Writing to file starts with empty line.
    File.open("#{@file_path}#{@filename}", 'w') do |writer|
      writer.puts("\n")
    end
    
    #From the tickets delivered in the given quarter, the job ids are gathered here
    @job_ids = @tickets.collect {|i| i.job_id }
    @jobs = Job.find(@job_ids)
    
    #To have less DB calls, all specie records are put into an instance variable
    @species = Specie.all
    
    #Goes through all the jobs, for each sums up all the mbf and tonnages and writes them into the file
    # per specie.
    @jobs.each do |k|
      @my_tickets = []
      @tickets.each do |l|
        if l.job_id == k.id
          @my_tickets.push(l)
        end
      end
      
      @amounts = []
      
      @species.length.times do
        @amounts.push([0, 0])
      end
      
      @total_pulp = 0
    
      @my_tickets.each do |i|
        i.load_details.each do |j|
          if i.wood_type == 3 || j.species_id == 0 #wood type 3 & species_id 0 == pulp
            @total_pulp = @total_pulp + j.tonnage
            next #If load is pulp, it has only one load detail so program jups to next loop
          end
          #Amounts of mbf/tonnage are summed up here per ticket according to their specie.
          @amounts[j.species_id-1][0] = @amounts[j.species_id-1][0] + j.mbfss #This and triple-n tonnage in next are helper methods. See their documentation.
          @amounts[j.species_id-1][1] = @amounts[j.species_id-1][1] + j.tonnnage
        end
      end
      
      #Finally, the values calculated above are written into the file.
      File.open("#{@file_path}#{@filename}", 'a') do |writer|
        writer.puts "Job, #{k.name}"
        writer.puts "Category, MBF, Tonnage"
        @species.each do |i|
          writer.puts "#{i.code}, #{round_to(@amounts[i.id-1][0].to_f, 2)}, #{round_to(@amounts[i.id-1][1].to_f, 2)}"
        end
        writer.puts "Pulp, ,#{round_to(@total_pulp.to_f, 2)}"
        writer.puts("\n")
      end
    end
    
    #The file created is opened in 'r' (== read) mode and send to user
    @file = File.open("#{@file_path}#{@filename}", 'r')
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
  def export_database

  end
  
  #Ajax action
  #The "thing" exported here can be of four different kind
  # 1. All the jobs
  # 2. All of the tickets
  # 3. All of the payments
  def export_the_thing
    #First, the file name, path and table headers will be set according to given id 
    if params[:id] == "1"
      @jobs = Job.all
      
      #Same filepath thingy here as above
      @filename = "Jobs_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "#{Rails.root}/../../shared/system/exports/"
      @table_name = "Jobs"
      @table_headers = "Name, Owner Name, Logger Name, Trucker Name, HFI-rate (%), HFI-prime" 
    end
    
    if params[:id] == "2"
      @tickets = Ticket.all
      
      @filename = "Tickets_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "#{Rails.root}/../../shared/system/exports/"
      @table_name = "Tickets"
      
      @species = ""
      Specie.all.each do |i|
        @species = "#{@species}, #{i.code}"
      end
      
      @table_headers = "Number, Delivery Date, Destination Name, Job Name, Wood Type#{@species}, Tonnage, Net MBF, Load Pay, Logger Pay, Trucker Pay, HFI Pay, Owner Pay"      
    end
    if params[:id] == "3"
      @payments = PaymentFromDestination.all
      
      @filename = "Payments_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "#{Rails.root}/../../shared/system/exports/"
      @table_name = "Payments"
      @table_headers = "Date, Destination Name, Job Name, Payment #, Wood Type, Net MBF, Tonnage, Total Payment"      
    end
    
    #Then, file is created with name and path set above and the headers are written to the file
    #After writing the headers, the data according to given id is written.
    File.open("#{@file_path}#{@filename}", "w") do |writer|
      writer.puts @table_name
      writer.puts @table_headers
      
      if params[:id] == "1"
        @jobs.each do |i|
          @puts = "#{i.name}, #{i.owner.name.gsub(',', '')}, #{i.logger.name.gsub(',', '')}, #{i.trucker.name.gsub(',', '')}, #{i.hfi_rate}, #{i.hfi_prime}"
          writer.puts @puts
        end
      end
      
      if params[:id] == "2"
        @tickets.each do |i|
          @amounts = []
          
          Specie.all.each do
            @amounts.push(0)
          end
          
          i.load_details.each do |j|
            unless j.mbfs.nil?
              @amounts[j.species_id-1] = j.mbfs
            else
              @amounts[j.species_id-1] = 0
            end
          end
          
          @amounts_str = ""
          @amounts.each do |j|
            @amounts_str = "#{@amounts_str}, #{j}"
          end
          
          if i.logger_rate.nil?   
           i.logger_value = 0
            else
          
            if i.logger_rate.rate_type == "MBF"
              i.logger_value = i.net_mbf * i.logger_rate.rate
              i.logger_value = i.logger_value.round(2)
            end
            if i.logger_rate.rate_type == "Tonnage"
              i.logger_value = i.tonnage * i.logger_rate.rate
              i.logger_value = i.logger_value.round(2)
            end
            if i.logger_rate.rate_type == "percent"
              i.logger_value = i.value * (i.logger_rate.rate/100)
              i.logger_value = i.logger_value.round(2)
            end
         end
          
          if i.trucker_rate.nil?
            i.trucker_value = 0
          else
            if i.trucker_rate.rate_type == "MBF"
              i.trucker_value = round_to(i.trucker_rate.rate*i.net_mbf, 2)
              else
                if i.trucker_rate.rate_type == "Tonnage"
                  i.trucker_value = round_to(i.trucker_rate.rate*i.tonnage, 2)
                  else
                  i.trucker_value = round_to(i.trucker_rate.rate/100*i.value, 2)
                end
            end
          end
          
          if i.job.hfi_rate.nil?
            i.hfi_value = 0
          else
            i.hfi_value = (i.job.hfi_rate/100)*i.value
          end
          
          i.owner_value = i.value - i.hfi_value - i.logger_value - i.trucker_value
          
          @puts = "#{i.number}, #{i.delivery_date}, #{i.destination.name.gsub(',', '')}, #{i.job.name.gsub(',', '')}, "
          @puts << "#{WoodType.find(i.wood_type).name}#{@amounts_str}, #{i.tonnage}, #{i.net_mbf}, #{give_pennies(i.value).gsub(',', '')}, #{give_pennies(i.logger_value).gsub(',', '')}, #{give_pennies(i.trucker_value).gsub(',', '')}, #{give_pennies(i.hfi_value).gsub(',', '')}, #{give_pennies(i.owner_value).gsub(',', '')}"
          writer.puts @puts
        end
      end
      
      if params[:id] == "3"
        @payments.each do |i|
          @puts = "#{i.payment_date}, #{i.destination.name.gsub(',', '')}, #{i.job.name.gsub(',', '')}, #{i.payment_num}, "
          @puts << "#{WoodType.find(i.wood_type).name}, #{i.tonnage}, #{i.net_mbf}, "
          @puts << "#{give_pennies(i.total_payment).gsub(',', '')}"
          writer.puts @puts
        end
      end
    end
    
    #Written file is opened for sending and sent
    @file = File.open("#{@file_path}#{@filename}", "r")
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
end

