class Destination < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact_person
  
  #def contact_person
  #  @contact_person = ContactPerson.find(self.contact_person_id)
  #end
  
end
