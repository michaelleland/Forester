class TruckerStatement < Prawn::Document
  def initialize(receipts, deduction_items, view)
    super()
    
    @view = view
    
    tickets = []
    tickets = receipts.collect {|i| i.tickets }
    tickets.flatten!
    
    date_string = Time.now.strftime('%m/%d/%Y')
    
    
    payment_total = 0
    receipts.each do |i|
      payment_total = payment_total + i.total_payment
    end
    
    deductions_total = 0
    deduction_items.each do |i|
      deductions_total = deductions_total + i[1].to_f
    end
    
    trucker_total = 0
    logger_total = 0 
    hfi_total = 0
    owner_total = 0
    load_pay_total = 0
    
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    logger = job.logger
    trucker = job.trucker
    
    tickets.each do |j|
      rate = TruckerRate.find_by_job_id_and_partner_id_and_destination_id(job.id, job.trucker.id, j.destination_id)
      if rate.rate_type == "MBF"
        j.trucker_value = rate.rate * j.net_mbf
      else
        if rate.rate_type == "Tonnage"
          j.trucker_value = rate.rate * j.tonnage
        else 
          if rate.rate_type == "percent"
            j.trucker_value = (rate.rate / 100) * j.value
          end
        end
      end
      
      trucker_total = trucker_total + j.trucker_value.round(2)
      load_pay_total = load_pay_total + j.value.round(2)
    end
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "Trucker Statement", :size=>25, :style=>:bold, :align => :center
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
      receipts.map do |i|
        [i.payment_num, i.receipt_date.strftime("%m/%d/%Y"), "Trucking pay", "", "$ #{give_pennies(i.total_payment)}"]
      end +
      [["", "", "", "<b>Total:</b>", "<u>$ #{give_pennies(payment_total)}</u>"]]
      
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
      
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Trucking Rate", "Load Pay", "Trucker Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%m/%d/%y"), shorten(i.destination.name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{give_pennies(i.trucker_rate.rate)} #{i.trucker_rate.rate_typee}", "#{give_pennies(i.value)}", "#{give_pennies(i.trucker_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{give_pennies(load_pay_total)}</b>", "<b>$ #{give_pennies(trucker_total)}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      columns(1..3).align = :center
      columns(4..8).align = :right
      column(0).align = :right
      column(6).align = :center
      rows(0).align = :left
      rows(0).background_color = "11AA22"
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