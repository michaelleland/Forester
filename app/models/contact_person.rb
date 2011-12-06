class ContactPerson < ActiveRecord::Base
  has_many :destinations
  has_many :owners
end
