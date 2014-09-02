class PetShelterController < ApplicationController
    
	def index
		@petsshelter = Pet.where(user_id: User.shelter_user_id)
		@petsshelter ||= []
	end
	
	def adopt
		hours_since_last_adopt = current_user.last_adopt ? ((Time.now - current_user.last_adopt)/1.hour).round : 25
		if current_user.pets.size >= Pet.adopt_limit
			redirect_to pet_shelter_path, alert: "There is a #{Pet.adopt_limit} pet limit currently in place.  You cannot adopt any more pets."
		elsif hours_since_last_adopt < 24
			redirect_to pet_shelter_path, alert: "You\'ve already adopted a pet in the last 24 hours.\nYou need to wait #{pluralize(24 - hours_since_last_adopt, 'hour')} before you can adopt another."
		else
			@pet = Pet.find(params[:pet])
			if @pet.user_id == User.shelter_user_id
				Pet.transaction do
					@pet.update_attributes(:user_id => current_user.id)
					current_user.update_attributes(:last_adopt => Time.now)
				end
				message = { notice: "You adopted #{@pet.name}!" }
			else
				message = { alert: "Pet has already been adopted :(" }
			end
			redirect_to house_path, message
		end
	end

	def give_up
		@pets = current_user.pets
	end

	def give_up_pets
		params[:pets].each do |pet_id|
			pet = Pet.where(id: pet_id, user: current_user).first
			pet.update_attributes(user_id: User.shelter_user_id)
		end
		redirect_to pet_shelter_path
	end

	def rename
		@pets = current_user.pets
	end

	def rename_pets
		pets = Pet.where(id: params[:pets].keys, user: current_user)
		renames = {}
		pets.each do |pet|
			new_name = params[:pets][pet.id.to_s][:name]
			renames[pet.id] = new_name if !new_name.eql?(pet.name)
		end

		total_cost = renames.size * 125
		if renames.size < 1
			message = { alert: 'You didn\'t rename any pets.' }
		elsif current_user.money < total_cost
			message = { alert: "You don\'t have enough money to rename #{pluralize(renames.size, 'pet')}."}
		else
			Pet.transaction do 
				current_user.update_attributes(money: current_user.money - total_cost)
				renames.each do |pet_id, new_name|
					Pet.update(pet_id.to_i, { name: new_name })
				end
			end

			message = { notice: "#{renames.size} #{renames.size == 1 ? 'pet was' : 'pets were'} renamed." }
		end

		redirect_to rename_path, message
	end

end