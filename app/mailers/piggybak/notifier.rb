module Piggybak
  class Notifier < ActionMailer::Base
    default :from => Piggybak.config.email_sender,
            :cc => Piggybak.config.order_cc

    def order_notification(order)
      @order = order

      begin
        if @order.respond_to? :locale
          initial_locale = I18n.locale
          I18n.locale = @order.locale || :en
        end
        mail(:to => order.email)
      ensure
        I18n.locale = initial_locale if initial_locale
      end
    end
    
    def staff_notification(order)
      @order = order

      mail(:to => Piggybak.config.staff_notification_email)
    end
  end
end
