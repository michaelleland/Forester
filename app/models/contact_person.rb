class ContactPerson < ActiveRecord::Base
  has_many :destinations
  has_many :owners
  has_many :partners
end
