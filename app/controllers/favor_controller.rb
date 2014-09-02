class FavorController < ApplicationController

  def index

  end

  def process_payment
    token = params[:stripeToken]
    quantity = params[:quantity].to_i
    if quantity < 100
      redirect_to bank_favor_path, alert: 'Please specify a quantity of at least 100.'
    else
      begin
        charge = Stripe::Charge.create(
          :amount => quantity, # amount in cents
          :currency => "usd",
          :card => token,
          :description => "Payment for #{quantity} TerrePets Favor from #{current_user.display_name}, #{current_user.email}."
        )
        puts "Card charged successfully"
        FavorTransaction.transaction do
          FavorTransaction.create({user_id: current_user.id, amount: charge[:amount], stripe_id: charge[:id], description: "Stripe payment - $#{sprintf('%.2f', charge[:amount].to_i/100.00)}"})
          current_user.update_attribute(:favor, current_user.favor + quantity)
        end
        redirect_to favor_history_path, notice: "Thank you for your payment!  You have been credited #{quantity} favor."
      rescue Stripe::CardError => e
        $stderr.puts "Rescued Stripe Card Error"
        redirect_to favor_path, alert: "There was an error processing your payment. #{e.message}"
      end
    end
  end

  def history
    if params.has_key?(:all) && current_user.is_admin
      @all = true
      @favor_transactions = FavorTransaction.all.order('created_at DESC')
    else
      @all = false
      @favor_transactions = current_user.favor_transactions.order('created_at DESC')
    end
  end

  def regraphic_pet
    @pets = current_user.pets.where(pet_template_type: 'StandardPetTemplate')
    @pet_templates = StandardPetTemplate.all
  end

  def regraphic_pet_update
    if current_user.favor < 50
        message = { alert: 'You do not have enough Favor to purchase a pet regraphic' }
    elsif !params[:pet]
      message = { alert: 'You need to specify a pet.' }
    elsif !params[:pet_template]
      message = { alert: 'You need to specify a new pet graphic.' }
    else
      pet = Pet.where(id: params[:pet], user: current_user)
      new_template = StandardPetTemplate.find(params[:pet_template])
      if pet.pet_template.is_a? CustomPetTemplate
        message = { alert: "#{pet.name} has a custom pet graphic and cannot have their graphic changed." }
      elsif pet.pet_template.id == new_template.id
        message = { alert: "#{pet.name} already has that graphic" }
      else
        Pet.transaction do
          current_user.update_attributes(favor: current_user.favor - 50)
          FavorTransaction.create({amount: -50, user_id: current_user.id, description: "Pet graphic change - #{pet.name} (##{pet.id})"})
          pet.update_attributes(pet_template: new_template)
        end
        message = { notice: "#{pet.name} has successfully been regraphicked!" }
      end
    end
    redirect_to message[:alert] ? favor_regraphic_pet_path : house_path , message
  end

  def custom_pet
    @pets = current_user.pets.where(pet_template_type: 'StandardPetTemplate')
  end

  def customize_pet
    if current_user.favor < 500
      message = { alert: 'You do not have enough Favor to customize a pet graphic.' }
    elsif !params[:pet_id]
      message = { alert: 'You need to specify a pet.' }
    elsif !params[:custom_image]
      message = { alert: 'You need to choose a file to upload for the pet graphic.' }
    elsif !params[:author] || params[:author].empty?
      message = { alert: 'You need to specify the author of the new graphic.' }
    else 
      pet = Pet.where(id: params[:pet_id], user: current_user)
      uploaded_file = params[:custom_image]
      if pet.pet_template.is_a? CustomPetTemplate
        message = { alert: "#{pet.name} already has a custom pet graphic." }
      elsif Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48
        message = { alert: 'Custom pet graphics can be no larger than 48px by 48px in dimension.' }
      else
        CustomPetTemplate.transaction do
          pet_template = CustomPetTemplate.create({name: "#{current_user.display_name} Custom Pet", uploader: current_user.id, author: params[:author], recipient: current_user.id, rights: 'Standard'})
          pet_template.set_image(uploaded_file)
          pet.update_attributes(pet_template: pet_template)
          current_user.update_attributes(favor: current_user.favor - 500)
          FavorTransaction.create({amount: -500, user_id: current_user.id, description: "Custom pet graphic - #{pet.name} (##{pet.id})"})
        end
        message = { notice: "#{pet.name} has successfully been customized!" }
      end
    end
    redirect_to message[:alert] ? favor_custom_pet_path : house_path, message
  end

  def transfer

  end

  def process_transfer
    puts params
    amount = params[:amount].to_i
    user = User.find_by(display_name: params[:user])
    messages = {}
    if user.nil?
      messages[:alert] = "There is no user by the name \"#{params[:user]}\""
    elsif current_user.id == user.id
      messages[:alert] = 'You can\'t transfer Favor to yourself.'
    elsif current_user.favor < amount
      messages[:alert] = "You do not have #{amount} favor to transfer."
    elsif amount < 1
      messages[:alert] = 'Please specify a postive amount of favor to transfer.'
    else
      User.transaction do
        current_user.update_attributes(favor: current_user.favor - amount)
        user.update_attributes(favor: user.favor + amount, has_unseen_mail: true)
        sending_user = params[:anonymous] ? 'An anoymous user' : "<a href='/users/#{current_user.id}'>#{current_user.display_name}</a>"
        mail_message = "#{sending_user} has transferred #{amount} Favor to you.  Check out the <a href='/favor/'>Favor</a> pages for various things you can do with your favor."
        InternalMail.create({
          from_user_id: 1, 
          to_user_id: user.id, 
          subject: 'Favor transfer!', 
          content: mail_message,
          from_user_name: 'TerrePets', 
          to_user_name: user.display_name
        })
        FavorTransaction.create({
          user_id: current_user.id, 
          amount: -amount, 
          description: "Favor transfer to <a href='/users/#{user.id}'>#{user.display_name}</a>"
        })
        transaction_message = params[:anonymous] ? "Favor transfer from an anonymous user" : "Favor transfer from <a href='/users/#{current_user.id}'>#{current_user.display_name}</a>"
        FavorTransaction.create({
          user_id: user.id,
          amount: amount,
          description: transaction_message
        })
      end
      messages[:notice] = "#{amount} Favor successfully transferred to #{user.display_name}."
    end

    redirect_to favor_transfer_path, messages
  end

  def tickets
    @tickets = Item.includes(:item_template).where(user_id: current_user.id, location: 0, item_template: ItemTemplate.find_by(name: "Magic Ticket"))
  end

  def redeem_tickets
    tickets = Item.where(id: params[:items], location: 0, user_id: current_user.id, item_template: ItemTemplate.find_by(name: "Magic Ticket"))
    num_tickets = tickets.size
    if num_tickets == 0
      puts "#{current_user.display_name} tried to redeem 0 tickets. Params:\n#{params}"
      redirect_to favor_tickets_path, alert: "You need to select some tickets to redeem."
    else
      favor = 0
      tickets.each { favor += Terrepets::TrueRandom.rand_range(3,54) }
      Item.transaction do 
        current_user.update_attributes(favor: current_user.favor + favor)
        Item.delete(tickets.map(&:id))
        FavorTransaction.create({
            user_id: current_user.id, 
            amount: favor, 
            description: "Favor recieved from #{num_tickets} Magic Ticket#{num_tickets == 1 ? '' : 's'}."
          })
      end
      redirect_to favor_tickets_path, notice: "#{num_tickets} Magic Ticket#{num_tickets == 1 ? ' has' : 's have'} been redeemed for #{favor} Favor."
    end
  end

end