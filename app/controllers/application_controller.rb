class ApplicationController < ActionController::Base
    include CanCan::ControllerAdditions

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path, alert: exception.message
    end
end

