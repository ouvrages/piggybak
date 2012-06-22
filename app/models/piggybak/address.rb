module Piggybak 
  class Address < ActiveRecord::Base
    belongs_to :state
    belongs_to :country

    validates_presence_of :firstname
    validates_presence_of :lastname
    validates_presence_of :address1
    validates_presence_of :city
    validates_presence_of :state_id, :if => proc { |address| address.country and address.country.states.size > 0 }
    validates_presence_of :country_id
    validates_presence_of :zip

    after_initialize :set_default_country
    
    attr_accessible :firstname, :lastname, :address1, :address2, :city, :country_id, :state_id, :zip

    def set_default_country
      self.country ||= Country.find_by_abbr(Piggybak.config.default_country)
    end

    def admin_label
      address = "#{self.firstname} #{self.lastname}<br />"
      address += "#{self.address1}<br />"
      if self.address2 && self.address2 != ''
        address += "#{self.address2}<br />"
      end
      address += "#{self.city}, #{self.state_display} #{self.zip}<br />"
      address += "#{self.country.name}"
      address
    end
    alias :display :admin_label  

    def state_display
      self.state ? self.state.name : self.state_id
    end
  end
end
