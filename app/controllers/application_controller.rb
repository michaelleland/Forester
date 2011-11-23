class ApplicationController < ActionController::Base
  protect_from_forgery
  
  $states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
  
  
  def round_to(x, d)
    rounded = (x * 10**d).round.to_f / 10**d
  end
  
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
  
end
