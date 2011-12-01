class HFIStatement < Prawn::Document
  def initialize(receipts, view)
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
    
    hfi_total = 0
    load_pay_total = 0
    
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    logger = job.logger
    trucker = job.trucker
     
    tickets.each do |j|      
      j.hfi_value = (j.value * (job.hfi_rate / 100)).round(2)
      hfi_total = hfi_total + j.hfi_value
      load_pay_total = load_pay_total + j.value
    end
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "HFI Statement", size: 25, style: :bold, :align => :center
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
      table_data = [["Payment Number", "Date", "Description", "", "Amount"]] + 
      receipts.map do |i|
        [i.payment_num, i.receipt_date.strftime("%m/%d/%Y"), "HFI pay", "", "$ #{give_pennies(i.total_payment)}"]
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
    
    deduction_items = []
    
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
    
    start_new_page(:layout => :landscape, :left_margin => 134, :right_margin => 5, :top_margin => 10, :bottom_margin => 10)
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "HFI Rate", "Load Pay", "HFI Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%d/%m/%y"), shorten(Destination.find(i.destination_id).name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{job.hfi_rate} %", "#{give_pennies(i.value)}", "#{give_pennies(i.hfi_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{give_pennies(load_pay_total)}</b>", "<b>$ #{give_pennies(hfi_total)}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      rows(0).background_color = "11AA22"
      columns(4..8).align = :right
      column(0).align = :right
      column(6).align = :center
      columns(1..3).align = :center
      rows(0).align = :left
      self.header = true
      self.row_colors = ["BABABA", "FFFFFF"]
      self.column_widths = [45, 60, 90, 60, 38, 38, 45, 70, 70]
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
end