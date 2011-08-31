class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :job
end
