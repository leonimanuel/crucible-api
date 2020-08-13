class ApplicationMailer < ActionMailer::Base
  default from: 'leon@crucible-beta.com'
  layout 'mailer'

  @@domain = "http://localhost:3001"
  # @@domain = "https://thecrucible.app"

  def new_discussion(creator, receiver, discussion)
  	@creator = creator
  	@receiver = receiver
  	@discussion = discussion
  	@url = @@domain
  	@specialtext = "hey there leon, emailing from croycible"
  	mail(to: @receiver.email, subject: "New discussion test")  	
  end

  def confirm_email(new_user, token)
    @new_user = new_user
    @token = token
    @url = "#{@@domain}/#{@token}/confirm-email"
    mail(to: "leonmalisov@gmail.com", subject: "Confirm your email") 
  end
end
