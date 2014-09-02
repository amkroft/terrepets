class UsersController < ApplicationController

  load_and_authorize_resource except: :online
  skip_load_resource only: [:index, :active]

	def index
    sort_order = sort_column + ' ' + sort_direction
    @users = User.where(is_npc: false).paginate(page: params[:page]).order(sort_order)
	end	

	def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user, :include => {:pets => { only: [:id, :name, :gender, :birthday] }}, only: [:id, :display_name, :is_admin, :created_at, :is_npc, :profile] }
    end
	end

  def edit
    raise CanCan::AccessDenied if !current_user.is_admin
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      message = { notice: "User #{user.display_name} updated" }
    else
      message = { alert: "User #{user.display_name} was not successfully updated" }
    end

    if user.id == current_user.id
      redirect_to my_account_index_path, message
    else
      redirect_to user_path(user), message
    end
  end

  def destroy
    if User.destroy(params[:id])
      message = { notice: 'User deleted.'}
    else
      message = { alert: 'User was not successfully deleted.'}
    end
    redirect_to users_path, message
  end

  def award
    @user = User.find(params[:id])
    @user.update_attributes(money: @user.money + 500)
    redirect_to users_path(@user), { notice: "#{@user.display_name} was awarded 500 monies."}
  end

  def active
    sort_order = sort_column + ' ' + sort_direction
    @users = User.where('last_active > ?', Time.now - 48.hours).paginate(page: params[:page]).order(sort_order)
  end

  def online
    sort_order = sort_column + ' ' + sort_direction
    @users = User.where('last_active > ?', Time.now - 10.minutes).paginate(page: params[:page]).order(sort_order)
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:display_name, :time_zone, :email, :money, :savings, :favor, :is_admin, :is_npc, :avatar_id, :avatar_type, :profile)
  end

  def sort_column
    if params[:sort_by] && [:display_name, :created_at, :email, :username, :last_active].include?(params[:sort_by].to_sym)
      params[:sort_by]
    else
      'display_name'
    end
  end

  def sort_direction
    direction = params[:direction] || 'asc'
    direction
  end

end