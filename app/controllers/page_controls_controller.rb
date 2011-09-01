class PageControlsController < ApplicationController
  
  def add_specie
    if $additions_counter > Specie.count
      render :nothing
    else
      $additions_counter = $additions_counter + 1
    end
    
  end

end
