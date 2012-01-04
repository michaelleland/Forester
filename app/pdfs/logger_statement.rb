class LoggerStatement < Prawn::Document
  def initialize(receipts, deduction_items, view)
    super()
    
    @view = view
    
    tickets = []
    receipts.each do |i|
      tickets.push(i.tickets)
    end
    tickets.flatten!
    
    load_pay_total = 0
    
    tickets.each do |i|
      load_pay_total = load_pay_total + round_to(i.value, 2)
      load_pay_total = round_to(load_pay_total, 2)
    end
    
    logger_total = 0
    
    tickets.each do |i|
      if i.logger_rate.rate_type == "MBF"
        i.logger_value = i.net_mbf.round(2) * i.logger_rate.rate.round(2)
        i.logger_value = i.logger_value.round(2)
      end
      if i.logger_rate.rate_type == "Tonnage"
        i.logger_value = i.tonnage.round(2) * i.logger_rate.rate.round(2)
        i.logger_value = i.logger_value.round(2)
      end
      if i.logger_rate.rate_type == "percent"
        i.logger_value = i.value.round(2) * (i.logger_rate.rate.round(2)/100)
        i.logger_value = i.logger_value.round(2)
      end
      
      logger_total = logger_total + i.logger_value
      logger_total = logger_total.round(2)
    end
    
    total = logger_total
        
    deduction_items.each do |i| 
      total = total - i[1].to_f.round(2)
      total = total.round(2)
    end
    
    #The total of all deductions in all of the receipts
    deductions_total = 0
    deduction_items.each do |i|
      deductions_total = deductions_total + i[1].to_f.round(2)
    end
    
    payments_total = 0
    
    receipts.each do |i|
      payments_total = payments_total + i.total_payment
    end
    
    job = Job.find(tickets.first.job_id)
    logger = job.logger
    trucker = job.trucker
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "Logger Statement", size: 25, style: :bold, :align => :center
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
      text "#{job.name}", :indent_paragraphs => 5
      text "#{job.owner.name}", :indent_paragraphs => 5
      text "#{logger.name}", :indent_paragraphs => 5
      text "#{trucker.name}", :indent_paragraphs => 5
    end
    
    grid([3, 0], [9, 9]).bounding_box do
      table_data = [["Payment number", "Date", "Description", "", "Amount"]] + 
      receipts.map do |i|
        [i.payment_num, i.receipt_date.strftime("%m/%d/%Y"), "Logging pay", "", "$ #{give_pennies(i.total_payment)}"]
      end +
      [["", "", "", "<b>Total:</b>", "<u>$ #{give_pennies(payments_total)}</u>"]]
      
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
    end
    
    move_down 15
    
    unless deduction_items.length == 0
      text "Deductions", :style => :bold, :size => 15
    
      move_down 5
      
      table_data = [["Payment Number", "", "Desription", "", "Amount"]] +
      deduction_items.map do |i|
      [i[2], "", i[0], "", "$ #{give_pennies(i[1].to_f)}"]
      end +
      [["", "", "", "<b>Total:</b>", "<u>$ #{give_pennies(deductions_total)}</u>"]]
      
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
    end
    
    start_new_page(:layout => :landscape, :left_margin => 124, :right_margin => 5, :top_margin => 10, :bottom_margin => 10)
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Logging Rate", "Load Pay", "Logger Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%d/%m/%y"), shorten(i.destination.name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{give_pennies(i.logger_rate.rate)} #{i.logger_rate.rate_typee}", "#{give_pennies(i.value)}", "#{give_pennies(i.logger_value)}"]
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