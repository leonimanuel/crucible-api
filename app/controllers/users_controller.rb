class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: [:create]

	def search
		# binding.pry
		if params["searchVal"]
			search_val = params["searchVal"].capitalize()
			users = User.where("name like ?", "%#{search_val}%").all 
			
			users = users.select do |user|
				user.id != @current_user.id && !params[:memberIds].include?(user.id)
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
		@user = @current_user
		if params[:id] === "extension"
			return render json: {
				id: @user.id, 
				name: @user.name, 
				email: @user.email, 
				unread_messages_count: MessagesUsersRead.where(user: @user, read: false).count
			}
		end
		# user = @current_user # || User.find(1)
		# render json: [{bok: "choy"}, JSON.parse(UserSerializer.new(user).to_serialized_json)]
		# binding.pry
		@facts = Fact.pending_review.all
		# binding.pry
		# render json: { login: LoginSerializer.new(user).to_json, review: ReviewSerializer.new(facts).to_json }
		render json: {
			user: ActiveModel::SerializableResource.new(@user, each_serializer: LoginSerializer),
			review: ActiveModel::SerializableResource.new(@facts, each_serializer: ReviewSerializer)
		} 
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






