class AuthenticationController < ApplicationController
 skip_before_action :authenticate_request

	def authenticate
	  command = AuthenticateUser.call(params[:email], params[:password])
  	if command.success?
			user = User.find_by(email: params[:email])
			group_names = user.groups.map {|g| g.name unless g.name == "Feed" || g.name == "Guest"}.compact
			
			if user.email_confirmed
				render json: { 
					auth_token: command.result, 
					user: {
						id: user.id, 
						name: user.name, 
						email: user.email,
						unread_messages_count: MessagesUsersRead.where(user: user, read: false).count,
						group_names: group_names
					} 
				}			
			else				
				confirmation_token = SecureRandom.urlsafe_base64.to_s
				user.update(confirm_token: confirmation_token)
				ApplicationMailer.confirm_email(user, confirmation_token).deliver_now
				binding.pry
				render json: { auth_token: command.result, message: "Please verify your account using the link emailed to you" }				
			end
	  else
	    render json: { error: command.errors }, status: :unauthorized
	  end
	end
end