class Address < ActiveRecord::Base
  has_many :destinations
  has_many :owners
end
