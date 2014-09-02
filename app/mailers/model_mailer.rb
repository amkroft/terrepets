class ModelMailer < ActionMailer::Base
  default from: "operations@terrepets.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #
  def new_record_notification(record)
    @record = record
    mail to: "recipient@terrepets.com", subject: "Success! You did it."
  end

  def create
    @record = Record.new
 
    if @record.save
      ModelMailer.new_record_notification(@record).deliver
      redirect_to @record
    end
  end

  def test_mail
    
     mail to: "admin@terrepets.com", subject: "Success! You've sent a test ."
    
  end

  def email_name
    mail({ :subject => "Mandrill rides the Rails!",
         :to      => ["moberlander08@gmail.com","amkroft@gmail.com"],
         :from    => "operations@terrepets.com" })
  end
end
