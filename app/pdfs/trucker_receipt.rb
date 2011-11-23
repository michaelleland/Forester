class TruckerReceipt < Prawn::Document
  def initialize(tickets, payment_num, deduction_items, notes, view)
    super()
    
    @view = view
    
    tickets = tickets
    payment_num = payment_num
    deduction_items = deduction_items
    notes = notes
    
    #Some utility stoof
    date_string = Time.now.strftime('%m/%d/%Y')
    #end utils
    
    #Total vars declared and initialized
    
    trucker_total = 0     
    load_pay_total = 0
    
    total = 0 #The final total after all those terrible calcs =)   
    
    job = Job.find(tickets.first.job_id)
    trucker = job.trucker
    logger = job.logger
    
    #Load pay total calculation
    tickets.each {|i| load_pay_total = load_pay_total + i.value }
    
    #Destination ids in tickets are gathered, duplicates removed and correspoding destinations
    # put into @destinations var
    destination_ids = tickets.collect {|i| i.destination_id }
    destination_ids = destination_ids.uniq
    
    destinations = Destination.find(destination_ids)
    
    #All tickets are given values for trucker_value, hfi_value and logger_value, with which
    # we can calculate owner_value by substracting them from ticket's value. Trucker and logger
    # totals are also added up in the midst of all this. 
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
      
      trucker_total = trucker_total + round_to(j.trucker_value, 2)
      
    end
    
    tickets.each {|i| load_pay_total = load_pay_total + round_to(i.value, 2)}
    
    total = trucker_total
    total_wo_deductions = trucker_total
      
    deduction_items.each {|i| total = total - round_to(i[1].to_f, 2) }
    
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
      text "#{job.name}", :indent_paragraphs => 5
      text "#{job.owner.name}", :indent_paragraphs => 5
      text "#{logger.name}", :indent_paragraphs => 5
      text "#{trucker.name}", :indent_paragraphs => 5
    end
    
    grid([3, 0], [9, 9]).bounding_box do
      table_data = [["Payment number", "Date", "Description", "", "Amount"]] + 
      [[payment_num, date_string, "Trucking pay", "", "$ #{give_pennies(trucker_total)}"]] +
      deduction_items.map do |i|
        ["", "", i[0], "", "$ #{give_pennies(i[1].to_f)}"]
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
      
    tickets_data = [["Ticket #", "Delivery Date", "Destination", "Wood Type", "MBF", "Tons", "Trucking Rate", "Load Pay", "Trucker Pay"]]+
    tickets.map do |i|
      [i.number, i.delivery_date.strftime("%d/%m/%y"), shorten(i.destination.name), WoodType.find(i.wood_type).name, give_pennies(i.net_mbf), give_pennies(i.tonnage), "#{give_pennies(i.trucker_rate.rate)} #{i.trucker_rate.rate_typee}", "#{give_pennies(i.value)}", "#{give_pennies(i.trucker_value)}"]
    end +
    [["", "", "", "", "", "", "<b>Totals</b>", "<b>$ #{give_pennies(load_pay_total)}</b>", "<b>$ #{give_pennies(total)}</b>"]]
    
    table tickets_data do
      row(0).font_style = :bold
      columns(1..3).align = :center
      columns(4..8).align = :right
      column(0).align = :right
      column(6).align = :center
      rows(0).align = :left
      rows(0).background_color = "33EE44"
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