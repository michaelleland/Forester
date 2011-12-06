module ApplicationHelper
  $active
  
  def esc_js(str)
    c = str.count("'")
    c.times { str.gsub!("'", "\\'") }
    str
  end
  
  def set_active active
    $active = active
  end
  
  def shorten str
    if str.length < 16
      return str
    else
      return "#{str[0..15]}..."
    end
  end
  
  #Documentation @ application_controller.rb
  def round_to(x, d)
    rounded = (x * 10**d).round.to_f / 10**d
  end
  
  #Documentation @ application_controller.rb
  def give_pennies(x)
    negative = false
    if x<0
      negative = true
      x = x.abs
    end
    
    x = round_to(x, 2)
    as_string = x.to_s
    
    if (as_string.length - as_string.index('.')) < 3
      as_string = "#{as_string}0"
    else
      if (as_string.length - as_string.index('.')) > 3
        as_string = as_string[0, as_string.index('.')+2]
      end
    end
    split_arr = as_string.split('.')
    
    integers = split_arr[0]
    length = integers.length
    if length > 3 && length < 7
      integers.reverse!
      integers.insert(3, ',')
      integers.reverse!
    end
    if length > 6
      integers.reverse!
      integers.insert(3, ',')
      integers.insert(7, ',')
      integers.reverse!
    end
    
    as_string = "#{integers}.#{split_arr[1]}"
    
    if negative
      as_string = "-#{as_string}"
    end
    
    as_string  
  end
  
  #Rounds a float to 2 decimals and adds 0 to the string representation of it which is then returned
  def give_decimals(x)
    x = round_to(x, 2)
    as_string = x.to_s
    
    if (as_string.length - as_string.index('.')) < 3
      as_string = "#{as_string}0"
    else
      if (as_string.length - as_string.index('.')) > 3
        as_string = as_string[0, as_string.index('.')+2]
      end
    end
    
    as_string
  end
end
