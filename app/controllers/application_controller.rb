class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_user_time_zone, :set_user_last_active

  include ActionView::Helpers::TextHelper

  def set_user_time_zone
    # TODO see if can cut down on calls to this method
    Time.zone = current_user.time_zone if user_signed_in?
  end

  def set_user_last_active
    current_user.update_last_active if user_signed_in?
  end
  
  def after_sign_in_path_for(user)
    house_path
  end 

  def after_sign_out_path_for(user)
    root_path
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  rescue_from CanCan::AccessDenied do |exception|
    if request.env["HTTP_REFERER"].nil?
      redirect_to house_path, alert: 'Access denied'
    else
      redirect_to :back, alert: 'Access denied.'
    end
  end

private

  def render_error(status, exception)
    $stderr.puts "EXCEPTION TIME ...::: #{Time.now.to_s}"
    $stderr.puts "EXCEPTION CLASS ..::: #{exception.class.name}"
    $stderr.puts "EXCEPTION MESSAGE ::: #{exception.message}"
    $stderr.puts "EXCEPTION STATUS .::: #{status}"
    if current_user
      $stderr.puts "CURRENT USER .....::: #{current_user.display_name}"
    else
      $stderr.puts "NO CURRENT USER"
    end
    $stderr.puts exception.backtrace.join("\n\t")
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

end
