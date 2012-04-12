class LoggerReceipt < Prawn::Document
  def initialize(tickets, payment_num, deduction_items, notes, view)
    super()
    
    @view = view
    
    
    #added by Michael after the fact to print the actual date the receipt was printed
    job = Job.find(tickets.first.job_id)
    logger_assignment = LoggerAssignment.find_by_job_id(job.id)
    logger = logger_assignment.partner_id
    receipt = Receipt.where(:job_id => job, :owner_id => logger, :payment_num => payment_num).first
    unless receipt == nil
      date_string = receipt.receipt_date.strftime('%m/%d/%Y')
    else
      date_string = Time.now.strftime('%m/%d/%Y')
    end
    
    
    load_pay_total = 0
    
    tickets.each do |i|
      load_pay_total = load_pay_total + round_to(i.value, 2)
      load_pay_total = round_to(load_pay_total, 2)
    end
    
    logger_total = 0
    
    tickets.each do |i|
      if i.logger_rate.rate_type == "MBF"
        i.logger_value = round_to(round_to(i.net_mbf, 2) * round_to(i.logger_rate.rate, 2), 2)
      end
      if i.logger_rate.rate_type == "Tonnage"
        i.logger_value = round_to(round_to(i.tonnage, 2) * round_to(i.logger_rate.rate, 2), 2)
      end
      if i.logger_rate.rate_type == "percent"
        i.logger_value = round_to((i.logger_rate.rate/100) * round_to(i.value, 2), 2)
      end
      
      logger_total = logger_total + i.logger_value
      logger_total = round_to(logger_total, 2)
    end
    
    total = 0
    
    job = Job.find(tickets.first.job_id)
    logger = job.logger
    trucker = job.trucker
    
    total = logger_total
        
    deduction_items.each do |i| 
      total = total - i[1].to_f.round(2)
      total = round_to(total, 2)
    end
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "Logger Receipt", :size=>25, :style=>:bold, :align => :center
    end
    
    grid([1, 2], [2, 6]).bounding_box do
      text "10 South Parkway Avenue Suite 201", :indent_paragraphs => 15
      text "Battle Ground, WA 98604", :indent_paragraphs => 15
      text "Ph. 360-723-5523", :indent_paragraphs => 15
      text "Fax. 360-723-5522", :indent_paragraphs => 15
    end
    
    grid([1, 6], [2, 7]).bounding_box do
      text "Job:", :style=>:bold, :indent_paragraphs => 5
      text "Owner:", :style=>:bold, :indent_paragraphs => 5
      text "Logger:", :style=>:bold, :indent_paragraphs => 5
      text "Trucker:", :style=>:bold, :indent_paragraphs => 5
    end
    
    grid([1, 7], [2, 9]).bounding_box do
      text "#{job.name}", :indent_paragraphs => 5
      text "#{job.owner.name}", :indent_paragraphs => 5
      text "#{logger.name}", :indent_paragraphs => 5
      text "#{trucker.name}", :indent_paragraphs => 5
    end
    
    grid([3, 0], [9, 9]).bounding_box do
      table_data = [["Payment number", "Date", "Description", "", "Amount"]] + 
      [[payment_num, date_string, "Logging pay", "", "$ #{give_pennies(logger_total)}"]] +
      deduction_items.map do |i|
        ["", "", i[0], "", "- $ #{give_pennies(i[1].to_f)}"]
      end +
      [["", "", "", "<b>Total:</b>", "<u>$ #{give_pennies(total)}</u>"]]
      
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
      
      unless notes == "" 
        text "Notes: #{notes}"
      end
    end
    
    start_new_page(:layout => :landscape, :left_margin => 124, :right_margin => 5, :top_margin => 10, :bottom_margin => 10)
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Logging Rate", "Load Pay", "Logger Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%m/%d/%y"), shorten(i.destination.name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{give_pennies(i.logger_rate.rate)} #{i.logger_rate.rate_typee}", "#{give_pennies(i.value)}", "#{give_pennies(i.logger_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{give_pennies(load_pay_total)}</b>", "<b>$ #{give_pennies(logger_total)}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      column(0).align = :right
      columns(4..8).align = :right
      columns(1..3).align = :center
      rows(0).background_color = "11AA22"
      rows(0).align = :left
      column(6).align = :center
      self.header = true
      self.row_colors = ["BABABA", "FFFFFF"]
      self.column_widths = [41, 46, 84, 48, 35, 35, 72, 90, 90]
      self.cell_style = {
        :size => 10,
        :padding => [2, 2, 2, 2],
        :inline_format => true,
        :border_colors => ["D1D1D1", "D1D1D1", "D1D1D1", "D1D1D1"]
      }
    end
  end
  
  def give_pennies(x)
    @view.give_pennies(x)
  end
  
  def shorten(str)
    @view.shorten(str)
  end
  
  def round_to(x, i)
    @view.round_to(x, i)
  end
end