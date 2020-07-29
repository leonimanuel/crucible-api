class InviteMailer < ActionMailer::Base
  default from: 'leon@crucible-beta.com'
  layout 'mailer'

  def invite(user)
  	# binding.pry
  	@user = user
  	@url = "http://crucible.com"
  	@specialtext = "hey there leon, emailing from croycible"
  	mail(to: "clairesustrickland@gmail.com", subject: "Email test")
  end
end
