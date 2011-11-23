class LoggerReceipt < Prawn::Document
  def initialize(tickets, payment_num, deduction_items, notes)
    super()
    
    #Some utility vars
    @date_string = Time.now.strftime('%m/%d/%Y')
    @ac = ApplicationController.new
    
    #end utils
    
    @deduction_items = deduction_items
    
    #stored into this var so when page is called as old receipt
    # we can fetch db notes and put them into same name bearing var
    # and happily render the page :)
    @notes = notes
    
    #Total vars declared and initialized
    @logger_total = 0 
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)
    @total_wo_deductions #Loggers total without deductions.
    
    @tickets = tickets
    
    @job = Job.find(@tickets.first.job_id)
    @logger = @job.logger
    @trucker = @job.trucker
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    #This is "inherited" if we are pulling out an old receipt
    @payment_num = payment_num
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    @destination_ids = @tickets.collect {|i| i.destination_id }
    @destination_ids = @destination_ids.uniq
    
    @destinations = Destination.find(@destination_ids)
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
    @tickets.each do |j|      
      @destinations.each do |i|
        if j.destination_id == i.id
          @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(i.id, j.job_id, @logger.id)
          if @rate.rate_type == "MBF"
            j.logger_value = @rate.rate * j.net_mbf
          else
            if @rate.rate_type == "Tonnage"
              j.logger_value = @rate.rate * j.tonnage
            else @rate.rate_type == "percent"
              if
                j.logger_value = (@rate / 100) *j.value
              end
            end
          end
        end
      end
      
      @logger_total = @logger_total + j.logger_value
      
    end
    
    @total = @logger_total
    
    @total_wo_deductions = @total
    
    @load_pay_total = 0
    
    @tickets.each do |i| 
      @load_pay_total = @load_pay_total + i.value
    end
    
    @deduction_items.each do |i| 
      @total = @total - i[1].to_f
    end
    
    @total = @ac.give_pennies(@total)
    
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
      [[@payment_num, @date_string, "Logging pay", "", "$ #{@ac.give_pennies(@logger_total)}"]] +
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
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Logging rate", "Load Pay", "Logger Pay"]]+
    @tickets.map do |i|
      [i.number, i.delivery_date, Destination.find(i.destination_id).name, WoodType.find(i.wood_type).name, @ac.give_pennies(i.net_mbf), @ac.give_pennies(i.tonnage), "$ #{i.logger_rate.rate} / #{i.logger_rate.rate_typee}", "$ #{@ac.give_pennies(i.value)}", "$ #{@ac.give_pennies(i.logger_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{@ac.give_pennies(@load_pay_total)}</b>", "<b>$ #{@total}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      columns(7..8).align = :right
      self.header = true
      self.row_colors = ["BABABA", "FFFFFF"]
      self.column_widths = [80, 75, 140, 70, 50, 50, 75, 90, 90]
      self.cell_style = {
        :size => 10,
        :padding => [2, 2, 2, 2],
        :inline_format => true,
        :border_colors => ["D1D1D1", "D1D1D1", "D1D1D1", "D1D1D1"]
      }
    end
  end
end