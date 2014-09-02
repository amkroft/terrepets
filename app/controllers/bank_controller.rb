class BankController < ApplicationController

	def index

	end

	def transact
		if params[:amount].to_i <=0  #Check to see if the user enters a valid number
			redirect_to bank_path, alert: 'Enter a number greater then 0.'	
		elsif params[:type] == 'deposit' && current_user.money < params[:amount].to_i
			redirect_to bank_path, alert: 'You do not have that much money on hand.'
		elsif params[:type] == 'withdraw' && current_user.savings < params[:amount].to_i
			redirect_to bank_path, alert: 'You do not have that much money in savings.'
		else
			if params[:type] == 'deposit'			
				newmoney= current_user.money - params[:amount].to_i
				newsavings= current_user.savings + params[:amount].to_i							
			elsif params[:type] == 'withdraw'
				newmoney = current_user.money + params[:amount].to_i
				newsavings= current_user.savings - params[:amount].to_i
			end
			current_user.update_attributes(:money => newmoney, :savings => newsavings)
			redirect_to bank_path
		end
	end


	def stars

	end


	def buy_stars
		quantity = params[:quantity].to_i || 0
		if quantity == 0
			message = { alert: 'Please specify a quantity to purchase.' }
		elsif quantity < 0
			message = { alert: 'Please enter a positive quantity.' }
		elsif current_user.money < 10*quantity
			message = {alert: "You don\'t have enough money to buy #{pluralize(quantity, 'star')}."}
		else
			current_user.stars += quantity
			current_user.money -= 10*quantity
			current_user.save
			message = {notice: "You bought #{pluralize(quantity,'star')}!"}			
		end
		redirect_to bank_stars_path, message
	end

end
