class ApplicationMailer < ActionMailer::Base
  default from: 'leon@crucible-beta.com'
  layout 'mailer'


  def new_discussion(creator, receiver, discussion)
  	binding.pry
  	@creator = creator
  	@receiver = receiver
  	@discussion = discussion
  	@url = "http://crucible.com"
  	@specialtext = "hey there leon, emailing from croycible"
  	mail(to: "leonmalisov@gmail.com", subject: "New discussion test")  	
  end
end
