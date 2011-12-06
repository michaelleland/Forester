class Owner < ActiveRecord::Base
  has_many :jobs
  
  belongs_to :address
  belongs_to :contact_person
end
