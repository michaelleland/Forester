class ContactPerson < ActiveRecord::Base
  has_many :destinations
end
