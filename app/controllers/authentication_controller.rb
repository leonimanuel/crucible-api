class AuthenticationController < ApplicationController
 skip_before_action :authenticate_request

	def authenticate
	  command = AuthenticateUser.call(params[:email], params[:password])
  	if command.success?
			user = User.find_by(email: params[:email])
			group_names = user.groups.map {|g| g.name unless g.name == "Feed" || g.name == "Guest"}.compact
			
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
	    render json: { error: command.errors }, status: :unauthorized
	  end
	end
end