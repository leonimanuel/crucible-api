class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: [:create]

	def index
		if request.headers["searchVal"]
			search_val = request.headers["searchVal"].capitalize()
			users = User.where("name like ?", "%#{search_val}%").all 
			
			users = users.select do |user|
				user.id != @current_user.id
			end
			# binding.pry
			render json: UserSerializer.new(users).to_serialized_json_lite
		
		else
			users = User.all
			render json: UserSerializer.new(users).to_serialized_json
		end

		# binding.pry
		
	end

	def show
		# binding.pry
		user = @current_user
		# user = @current_user # || User.find(1)
		# render json: [{bok: "choy"}, JSON.parse(UserSerializer.new(user).to_serialized_json)]
		# binding.pry
		render json: LoginSerializer.new(user).to_json
		# render json: UserSerializer.new(user).to_serialized_json
		# render json: Topic.find(3).subtree.arrange_serializable
	end

	def create
		user = User.new(name: params[:name], email: params[:email], password: params[:password])
		if user.valid? && !User.find_by(email: params[:email])
			user.save
			user.topics << Topic.create(name: "New Facts", user: user)
			
			command = AuthenticateUser.call(user.email, user.password)
			render json: { auth_token: command.result, user: {id: user.id, name: user.name, email: user.email} }
		end
	end

	def invite
		# binding.pry
		user = @current_user
		# InviteMailer.invite_email(user).deliver_now
		InviteMailer.invite(user).deliver_now
	end
end






