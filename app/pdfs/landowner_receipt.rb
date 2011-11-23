class LandownerReceipt < Prawn::Document
  def initialize(tickets, payment_num, deduction_items, notes)
    super()
    
    #Some utility vars
    @date_string = Time.now.strftime('%m/%d/%Y')
    @ac = ApplicationController.new
    
    #end utils
    
    #stored into this var so when page is called as old receipt
    # we can fetch db notes and put them into same name bearing var
    # and happily render the page :)
    @notes = notes
    
    #Total vars declared and initialized
    
    @trucker_total = 0
    @logger_total = 0 
    @hfi_total = 0
    @load_pay_total = 0
    
    @total = 0 #The final total after all those terrible calcs =)
    @total_wo_deductions #Owners total without deductions.
    
    @tickets = tickets
    
    @job = Job.find(@tickets.first.job_id)
    @owner = @job.owner
    @logger = @job.logger
    @trucker = @job.trucker
    
    #Load pay total calculation
    @tickets.each {|i| @load_pay_total = @load_pay_total + i.value }
    
    @payment_num = payment_num
    
    @deduction_items = deduction_items
    
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
      
      j.hfi_value = j.value * (@job.hfi_rate / 100)
      @hfi_total = @hfi_total + j.hfi_value
      
      @rate = LoggerRate.find_by_destination_id_and_job_id_and_partner_id(j.destination_id, j.job_id, @job.logger.id)
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
      
      @logger_total = @logger_total + j.logger_value
      
      j.owner_value = j.value - j.logger_value - j.trucker_value - j.hfi_value
    end
    
    @tickets.each {|i| @total = @total + i.owner_value.to_f }
    
    @owner_total = @total.to_f
    
    @deduction_items.each {|i| @total = @total - i[1].to_f }
    
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
      [[@payment_num, @date_string, "Landowner portion", "", "$ #{@ac.give_pennies(@logger_total)}"]] +
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
    
    start_new_page(:layout => :landscape, :left_margin => 5, :right_margin => 5, :top_margin => 10, :bottom_margin => 10)
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Logging Rate", "Trucking Rate", "HFI Rate", "Load Pay", "Logger Pay", "Trucker Pay", "HFI Pay", "Owner Pay"]]+
    @tickets.map do |i|
      [i.number, i.delivery_date, Destination.find(i.destination_id).name, WoodType.find(i.wood_type).name, @ac.give_pennies(i.net_mbf), @ac.give_pennies(i.tonnage), "$ #{i.logger_rate.rate} / #{i.logger_rate.rate_typee}", "$ #{i.trucker_rate.rate} / #{i.trucker_rate.rate_typee}", "#{@job.hfi_rate} %", "$ #{@ac.give_pennies(i.value)}", "$ #{@ac.give_pennies(i.logger_value)}", "$ #{@ac.give_pennies(i.trucker_value)}", "$ #{@ac.give_pennies(i.hfi_value)}", "$ #{@ac.give_pennies(i.owner_value)}"]
    end +
    [["", "", "", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{@ac.give_pennies(@load_pay_total)}</b>", "<b>$ #{@ac.give_pennies(@logger_total)}</b>", "<b>$ #{@ac.give_pennies(@trucker_total)}</b>", "<b>$ #{@ac.give_pennies(@hfi_total)}</b>", "<b>$ #{@ac.give_pennies(@owner_total)}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      columns(4..13).align = :right
      column(8).align = :center
      self.header = true
      self.row_colors = ["BABABA", "FFFFFF"]
      self.column_widths = [36, 58, 84, 48, 35, 35, 67, 67, 35, 63, 63, 63, 63, 64.5]
      self.cell_style = {
        :size => 10,
        :padding => [2, 2, 2, 2],
        :inline_format => true,
        :border_colors => ["D1D1D1", "D1D1D1", "D1D1D1", "D1D1D1"]
      }
    end
  end
  
  
end