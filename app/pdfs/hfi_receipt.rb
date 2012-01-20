class HFIReceipt < Prawn::Document
  def initialize(tickets, payment_num, notes, view)
    super()
    
    @view = view
    
    #Some utility vars
    date_string = Time.now.strftime('%m/%d/%Y')
    
    #Total vars declared and initialized 
    hfi_total = 0
    load_pay_total = 0
    
    job = Job.find(tickets.first.job_id)
    owner = job.owner
    logger = job.logger
    trucker = job.trucker
    
    tickets.each do |j|
      j.hfi_value = j.value * (job.hfi_rate / 100)
      hfi_total = hfi_total + j.hfi_value.round(2)
      load_pay_total = load_pay_total + j.value
    end
    
    hfi_logo = "#{Rails.root}/public/images/HFI_logo.png"
    
    define_grid(:columns => 10, :rows => 14, :gutter => 10)
    grid([0, 0], [2, 2]).bounding_box do
      image hfi_logo, :position => :left, :scale => 0.6
    end
    
    grid([0, 2], [0, 9]).bounding_box do
      text "HFI Receipt", size: 25, style: :bold, :align => :center
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
      [[payment_num, date_string, "HFI pay", "", "$ #{give_pennies(hfi_total)}"]] +
      [["", "", "", "<b>Total:</b>", "<u>$ #{give_pennies(hfi_total)}</u>"]]
      
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
    
    start_new_page(:layout => :landscape, :left_margin => 134, :right_margin => 5, :top_margin => 10, :bottom_margin => 10)
    
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "HFI Rate", "Load Pay", "HFI Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%m/%d/%y"), shorten(i.destination.name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{job.hfi_rate} %", "#{give_pennies(i.value)}", "#{give_pennies(i.hfi_value)}"]
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
  
  def round_to(x, i)
    @view.round_to(x, i)
  end
end