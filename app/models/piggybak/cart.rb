module Piggybak
  class Cart
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    
    attr_accessor :name
    attr_accessor :items
    attr_accessor :total
    attr_accessor :errors
    attr_accessor :extra_data
  
    def initialize(cookie='')
      self.items = []
      @errors = ActiveModel::Errors.new(self)
      cookie ||= ''
      cookie.split(';').each do |item|
        item_variant = Piggybak::Variant.find_by_id(item.split(':')[0])
        if item_variant.present?
          self.items << { :variant => item_variant, :quantity => (item.split(':')[1]).to_i }
        end
      end
      self.total = self.items.sum { |item| item[:quantity]*item[:variant].price }

      self.extra_data = {}
    end
  
    def self.to_hash(cookie)
      cookie ||= ''
      cookie.split(';').inject({}) do |hash, item|
        hash[item.split(':')[0]] = (item.split(':')[1]).to_i
        hash
      end
    end
  
    def self.to_string(cart)
      cookie = ''
      cart.each do |k, v|
        cookie += "#{k.to_s}:#{v.to_s};" if v.to_i > 0
      end
      cookie
    end

    def self.add(cookie, params)
      cart = to_hash(cookie)
      cart["#{params[:variant_id]}"] ||= 0
      cart["#{params[:variant_id]}"] += params[:quantity].to_i
      to_string(cart)
    end
  
    def self.remove(cookie, variant_id)
      cart = to_hash(cookie)
      cart[variant_id] = 0
      to_string(cart)
    end
  
    def self.update(cookie, params)
      cart = to_hash(cookie)
      cart.each { |k, v| cart[k] = params[:quantity][k].to_i }
      to_string(cart)
    end
 
    def to_cookie
      cookie = ''
      self.items.each do |item|
        cookie += "#{item[:variant].id.to_s}:#{item[:quantity].to_s};" if item[:quantity].to_i > 0
      end
      cookie
    end
  
    def update_quantities
      self.errors.clear
      new_items = []
      self.items.each do |item|
        if !item[:variant].active
          self.errors.add(:base, :item_no_longer_available, :description =>  item[:variant].description)
        elsif item[:variant].unlimited_inventory || item[:variant].quantity >= item[:quantity]
          new_items << item
        elsif item[:variant].quantity == 0
          self.errors.add(:base, :item_no_longer_available, :description =>  item[:variant].description)
        else
          self.errors.add(:base, :item_available_in_limited_quantity, :description =>  item[:variant].description, :quantity => item[:variant].quantity)
          item[:quantity] = item[:variant].quantity
          new_items << item if item[:quantity] > 0
        end
      end
      self.items = new_items
      self.total = self.items.sum { |item| item[:quantity]*item[:variant].price }
    end

    def set_extra_data(form_params)
      form_params.each do |k, v|
        self.extra_data[k.to_sym] = v if ![:controller, :action].include?(k)
      end
    end
  end
end
