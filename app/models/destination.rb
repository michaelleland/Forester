class Destination < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact_person
  
  has_many :tickets
  has_many :payment_from_destinations
end
