module Piggybak
  module Config
    class << self
      attr_accessor :payment_calculators
      attr_accessor :shipping_calculators
      attr_accessor :tax_calculators
      attr_accessor :default_country
      attr_accessor :activemerchant_mode
      attr_accessor :payment_flow

      def reset
        @payment_calculators = ["::Piggybak::PaymentCalculator::Fake",
                                "::Piggybak::PaymentCalculator::AuthorizeNet"]
        @shipping_calculators = ["::Piggybak::ShippingCalculator::FlatRate",
                                 "::Piggybak::ShippingCalculator::Free",
                                 "::Piggybak::ShippingCalculator::Range"]
        @tax_calculators = ["::Piggybak::TaxCalculator::Percent"]

        @default_country = "US"

        @activemerchant_mode = :production
        
        @payment_flow = :gateway
      end
    end

    self.reset
  end
end
