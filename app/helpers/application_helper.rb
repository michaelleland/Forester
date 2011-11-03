module ApplicationHelper
  $active
  
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
  
end
