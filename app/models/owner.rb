class Owner < ActiveRecord::Base
  def address
    @address = Address.find(self.address_id)
  end
  
  def contact_person
    @contact_person = ContactPerson.find(self.contact_person_id)
  end
end
