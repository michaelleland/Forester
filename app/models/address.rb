class Address < ActiveRecord::Base
  has_many :destinations
end
