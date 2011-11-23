class TruckerReceipt < Prawn::Document
  def initialize(tickets, payment_num, deduction_items, notes)
    super()
    
    @tickets = tickets
    @payment_num = payment_num
    @deduction_items = deduction_items
    @notes = notes
    
    @ac = ApplicationController.new
    
    #Some utility stoof
    @date_string = Time.now.strftime('%m/%d/%Y')
    #end utils
    
    #Total vars declared and initialized
    
    @trucker_total = 0     
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)   
    
    @job = Job.find(@tickets.first.job_id)
    @trucker = @job.trucker
    @logger = @job.logger
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    #Truckers rate, needs to be shown in tickets list
    @rate
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
    @tickets.each do |j|
      @rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(@job.id, @job.trucker.id, j.destination_id)
      if @rate.rate_type == "MBF"
        j.trucker_value = @rate.rate * j.net_mbf
      else
        if @rate.rate_type == "Tonnage"
          j.trucker_value = @rate.rate * j.tonnage
        else 
          if @rate.rate_type == "percent"
            j.trucker_value = (@rate.rate / 100) * j.value
          end
        end
      end
      
      @trucker_total = @trucker_total + j.trucker_value
      
    end
    
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    @total = @trucker_total
    @total_wo_deductions = @trucker_total
      
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
    @total = @ac.give_pennies(@total)
    
    @pages = []
    
    @tickets_count = @tickets.length
    @pages_count = @tickets_count/44
    if @tickets_count%44 != 0
      @pages_count = @pages_count+1
    end
    
    @counter = 0
    @pages_count.times do
      @pages.push(@counter)
      @counter = @counter+44
    end
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "Trucker Receipt", size: 25, style: :bold, :align => :center
    end
    
    grid([1, 2], [2, 6]).bounding_box do
      text "10 South Parkway Avenue Suite 201", :indent_paragraphs => 15
      text "Battle Ground, WA 98604", :indent_paragraphs => 15
      text "Ph. 360-723-5523", :indent_paragraphs => 15
      text "Fax. 360-723-5522", :indent_paragraphs => 15
    end
    
    grid([1, 6], [2, 7]).bounding_box do
      text "Job:", style: :bold, :indent_paragraphs => 5
      text "Owner:", style: :bold, :indent_paragraphs => 5
      text "Logger:", style: :bold, :indent_paragraphs => 5
      text "Trucker:", style: :bold, :indent_paragraphs => 5
    end
    
    grid([1, 7], [2, 9]).bounding_box do
      text "#{@job.name}", :indent_paragraphs => 5
      text "#{@job.owner.name}", :indent_paragraphs => 5
      text "#{@logger.name}", :indent_paragraphs => 5
      text "#{@trucker.name}", :indent_paragraphs => 5
    end
    
    grid([3, 0], [9, 9]).bounding_box do
      table_data = [["Payment number", "Date", "Description", "", "Amount"]] + 
      [[@payment_num, @date_string, "Trucking pay", "", "$ #{@ac.give_pennies(@trucker_total)}"]] +
      @deduction_items.map do |i|
        ["", "", i[0], "", "$ #{@ac.give_pennies(i[1].to_f)}"]
      end +
      [["", "", "", "<b>Total:</b>", "<u>$ #{@total}</u>"]]
      
      table table_data do
        row(0).font_style = :bold
        columns(3..4).align = :right
        self.column_widths = [110, 75, 155, 70, 130]
        self.cell_style = {
          :borders => [],
          :padding => [1, 0, 1, 0],
          :inline_format => true
        }
      end
      
      move_down 15
      
      unless @notes == "" 
        text "Notes: #{@notes}"
      end
    end
    
    start_new_page(:layout => :landscape)
      
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Trucking rate", "Load Pay", "Trucker Pay"]]+
    @tickets.map do |i|
      [i.number, i.delivery_date, Destination.find(i.destination_id).name, WoodType.find(i.wood_type).name, @ac.give_pennies(i.net_mbf), @ac.give_pennies(i.tonnage), "$ #{i.trucker_rate.rate} / #{i.trucker_rate.rate_typee}", "$ #{@ac.give_pennies(i.value)}", "$ #{@ac.give_pennies(i.trucker_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{@ac.give_pennies(@load_pay_total)}</b>", "<b>$ #{@total}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      columns(7..8).align = :right
      self.header = true
      self.row_colors = ["BABABA", "D2D2D2"]
      self.column_widths = [80, 75, 140, 70, 50, 50, 75, 90, 90]
      self.cell_style = {
        :size => 10,
        :padding => [2, 2, 2, 2],
        :inline_format => true
      }
    end
  end
end