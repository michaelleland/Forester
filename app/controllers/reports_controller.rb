class ReportsController < ApplicationController
  layout nil
  
  def index
    
  end
  
  def quarterly_report
    
  end
  
  def exported_report
    @filename = "quarterly_report_#{params[:year]}_#{params[:quarter]}.csv"
    @file_path = "../../shared/system/exports/"
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
    
    File.open("#{@file_path}#{@filename}", 'w') do |writer|
      writer.puts("\n")
    end
    
    @job_ids = @tickets.collect {|i| i.job_id }
    @jobs = Job.find(@job_ids)
    
    @species = Specie.all
    
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
          if i.wood_type == 3 || j.species_id == 0
            @total_pulp = @total_pulp + j.tonnage
            next
          end
          @amounts[j.species_id-1][0] = @amounts[j.species_id-1][0] + j.mbfss
          @amounts[j.species_id-1][1] = @amounts[j.species_id-1][1] + j.tonnnage
        end
      end
      
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
    
    @file = File.open("#{@file_path}#{@filename}", 'r')
    
    send_data(@file.read, :type => "csv", :filename => @filename)
    
  end
  
  def export_database

  end
  
  def export_the_thing
    if params[:id] == "1"
      @jobs = Job.all
      
      @filename = "Jobs_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "../../shared/system/exports/"
      @table_name = "Jobs"
      @table_headers = "Name, Owner Name, Logger Name, Trucker Name, HFI-rate (%), HFI-prime" 
    end
    
    if params[:id] == "2"
      @tickets = Ticket.all
      
      @filename = "Tickets_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "../../shared/system/exports/"
      @table_name = "Tickets"
      
      @species = ""
      Specie.all.each do |i|
        @species = "#{@species}, #{i.code}"
      end
      
      @table_headers = "Number, Delivery Date, Destination Name, Job Name, Wood Type#{@species}, Tonnage, Net MBF, Load Pay"      
    end
    if params[:id] == "3"
      @payments = PaymentFromDestination.all
      
      @filename = "Payments_on_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}.csv"
      @file_path = "../../shared/system/exports/"
      @table_name = "Payments"
      @table_headers = "Date, Destination Name, Job Name, Payment #, Wood Type, Net MBF, Tonnage, Total Payment"      
    end
    
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
          
          @puts = "#{i.number}, #{i.delivery_date}, #{i.destination.name.gsub(',', '')}, #{i.job.name.gsub(',', '')}, "
          @puts << "#{WoodType.find(i.wood_type).name}#{@amounts_str}, #{i.tonnage}, #{i.net_mbf}, #{give_pennies(i.value).gsub(',', '')}"
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
    
    @file = File.open("#{@file_path}#{@filename}", "r")
    
    send_data(@file.read, :type => "csv", :filename => @filename)
  end
  
end
