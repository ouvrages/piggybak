require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
	  class Download < RailsAdmin::Config::Actions::Base
	    RailsAdmin::Config::Actions.register(self)

		register_instance_option :controller do
		  Proc.new do
		    Rails.logger.warn "steph inside here!!!"
		    redirect_to root_url #render "blah"
		  end
		end
      end
    end
  end
end
