class ApplicationMailer < ActionMailer::Base
  default from: 'leon@crucible-beta.com'
  layout 'mailer'

  @@domain = "http://localhost:3001"
  # @@domain = "https://thecrucible.app"

  def new_discussion(creator, receiver, discussion)
    @creator = creator
  	@receiver = receiver
  	@discussion = discussion
  	@url = "#{@@domain}/groups/#{discussion.group.name.split(" ").join("-")}/discussions/#{discussion.slug}-#{discussion.id}"
    "/groups/The-Fam/discussions/kimberly-guilfoyle-2020-rnc-speech-transcript-7"
  	@specialtext = "hey there leon, emailing from croycible"
  	mail(to: @receiver.email, subject: "New discussion in #{@discussion.group.name}")  	
  end

  def confirm_email(new_user, token)
    @new_user = new_user
    @token = token
    @url = "#{@@domain}/#{@token}/confirm-email"
    mail(to: @new_user.email, subject: "Confirm your email") 
  end

  def discussion_invite(guest, inviter, discussion)
    puts "WOW GEE THANKS FOR THE INVITE GUY"    
  end

  def send_feedback(user, feedback)
    @user = user
    @feedback = feedback
    mail(to: "leon@crucible-beta.com", subject: "Feedback from #{user.name}") 
  end

  def new_game(discussion, user)
    @discussion = discussion
    @user = user
    @discussion_url = "#{@@domain}/groups/#{discussion.group.name.split(" ").join("-")}/discussions/#{discussion.slug}-#{discussion.id}"
    
    mail(to: "leon@crucible-beta.com", subject: "New Game")
  end
end





