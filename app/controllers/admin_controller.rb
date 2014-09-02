require 'net/https'
class AdminController < ApplicationController

	def index
		raise CanCan::AccessDenied if !current_user.is_admin
	end

	def email_name
		raise CanCan::AccessDenied if !current_user.is_admin
		puts ModelMailer.email_name.deliver
    redirect_to admin_path, notice: "Message has been sent"
	end

	def check_status
		raise CanCan::AccessDenied if !current_user.is_admin
		
		uri = URI.parse("REDACTED")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)
		result= JSON.parse(response.body)
		@droplets = result['droplets']
	end


end



