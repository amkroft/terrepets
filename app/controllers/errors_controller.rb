class ErrorsController < ApplicationController
  
  
  def error_404
    $stderr.puts "Hit error_404 in ErrorsController"
    $stderr.puts "Parameters: #{params}"
    @not_found_path = params[:not_found]
    respond_to do |format|
      format.html { render :template => "errors/error_404", :status => 404 }
      format.all { render :nothing => true, :status => 404 }
    end
  end

  def error_500
    $stderr.puts "Hit error_500 in ErrorsController"
    $stderr.puts "Parameters: #{params}"
    $stderr.puts caller
    respond_to do |format|
      format.html { render :template => "errors/error_500", :status => 500 }
      format.all { render :nothing => true, :status => 500 }
    end
  end
end
