class InternalMailController < ApplicationController

  # load_resource

	def index
		@internal_mails = InternalMail.where(:to_user_id => current_user.id).order('created_at DESC')
    current_user.update_attributes(has_unseen_mail: false) if current_user.has_unseen_mail
	end

	def new
    @internal_mail = InternalMail.new
    if params[:reply_to]
      @reply_mail = InternalMail.find(params[:reply_to])
      @internal_mail.to_user_id = @reply_mail.from_user_id
      @internal_mail.to_user_name = @reply_mail.from_user_name
      @internal_mail.subject = "Re: #{@reply_mail.subject}"
      @internal_mail.content = "\n\n-- Message from <strong>#{@reply_mail.from_user_name}</strong> --\n#{@reply_mail.content}"
    elsif params[:to_user_id]
      @internal_mail.to_user_id = params[:to_user_id]
      @internal_mail.to_user_name = params[:to_user_name]
    end
	end

	def create
		@internal_mail = InternalMail.new(internal_mail_params)
    @internal_mail.from_user_id = current_user.id
    @internal_mail.from_user_name = current_user.display_name
    to_user = User.find_by(display_name: @internal_mail.to_user_name)
    if to_user.nil?
      render action: 'new', alert: "Could not find user #{@internal_mail.to_user_name}"
    else
      @internal_mail.to_user_id = to_user.id
      @internal_mail.to_user_name = to_user.display_name
      if @internal_mail.save
        # render action: 'index', notice: 'Message sent!'
        to_user.update_attributes(has_unseen_mail: true) if !to_user.has_unseen_mail
        redirect_to internal_mail_index_path, { notice: 'Message sent!' }
      else
        render action: 'new'
      end
    end
	end

  def show
    @internal_mail = InternalMail.find(params[:id])
    raise CanCan::AccessDenied if current_user.id != @internal_mail.to_user_id
    @internal_mail.update_attributes(read: true) if !@internal_mail.read
    @internal_mail.content.gsub!(/\n/,'<br>')
  end

  def mdestroy
    mails = InternalMail.where(id: params['mail'], to_user_id: current_user.id)
    if mails.any?
      InternalMail.delete(mails.map(&:id))
      redirect_to internal_mail_index_path, notice: "#{mails.size} messages deleted."
    else
      redirect_to internal_mail_index_path, alert: "No valid messages were selected."
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_internal_mail
    @internal_mail = InternalMAil.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def internal_mail_params
    params.require(:internal_mail).permit(:from_user_id, :to_user_id, :to_user_name, :read, :subject, :content)
  end

end