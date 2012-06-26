module Piggybak
  class Notifier < ActionMailer::Base
    default :from => Piggybak.config.email_sender,
            :cc => Piggybak.config.order_cc

    def order_notification(order)
      @order = order

      mail(:to => order.email)
    end
    
    def staff_notification(order)
      @order = order

      mail(:to => Piggybak.config.staff_notification_email)
    end
  end
end
