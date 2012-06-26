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

    def admin_label(format = :html)
      case format
      when :html
        separator = "<br />"
      when :text
        separator = "\n"
      else
        raise "Invalid format: #{format.inspect}"
      end
      address = []
      address << "#{self.firstname} #{self.lastname}"
      address << "#{self.address1}"
      if self.address2.present?
        address << "#{self.address2}"
      end
      address << "#{self.city}, #{self.state_display} #{self.zip}"
      address << "#{self.country.name}"
      address.join(separator)
    end
    alias :display :admin_label  

    def state_display
      self.state ? self.state.name : self.state_id
    end
  end
end
