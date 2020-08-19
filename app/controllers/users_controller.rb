class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: [:create, :confirm_email]

	def search
		if params["searchVal"]
			search_val = params["searchVal"].capitalize()
			users = User.where("name like ?", "%#{search_val}%").all 
			
			users = users.select do |user|
				user.id != @current_user.id && !params[:memberIds].include?(user.id) && !params[:addedUserIds].include?(user.id)
			end
			render json: UserSerializer.new(users).to_serialized_json_lite
		
		else
			users = User.all
			render json: UserSerializer.new(users).to_serialized_json
		end	
	end

	def show
		@user = @current_user
		if params[:id] === "extension"
			group_names = @user.groups.map {|g| g.name unless g.name == "Feed" || g.name == "Guest"}.compact

			return render json: {
				id: @user.id, 
				name: @user.name, 
				email: @user.email, 
				unread_messages_count: MessagesUsersRead.where(user: @user, read: false).count,
				group_names: group_names
			}
		end

		render json: {
			user: ActiveModel::SerializableResource.new(@user, each_serializer: LoginSerializer),
			review: ActiveModel::SerializableResource.new(@user, each_serializer: ReviewSerializer)
		} 
	end

	def create
		user = User.new(name: params[:name], last_name: params[:lastName], handle: params[:handle], email: params[:email], password: params[:password])

		if user.valid? && !User.find_by(email: params[:email])
			user.save
			confirmation_token = SecureRandom.urlsafe_base64.to_s
			user.update(confirm_token: confirmation_token)
			
			user.topics << Topic.create(name: "New Facts", user: user)
			feed = Group.create(name: "Feed", admin: user)
			guest = Group.create(name: "Guest", admin: user)
			feed.users << user
			guest.users << user

	    ApplicationMailer.confirm_email(user, confirmation_token).deliver_now
			
			command = AuthenticateUser.call(params[:email], params[:password])
			render json: { auth_token: command.result, message: "Please verify your account using the link just sent to your email" }
		else
			if !user.errors.details[:email].empty?
				render json: {error: "An account with this email already exists"}
			elsif !user.errors.details[:handle].empty?
				render json: {error: "handle already taken, please choose another"}				
			end
		end
	end

	def invite
		user = @current_user
		InviteMailer.invite(user).deliver_now
	end

	def confirm_email
		user = User.find_by(confirm_token: params[:token])
		if user
			user.update(email_confirmed: true, confirm_token: nil)

			instruction_discussion = Discussion.create(
				name: "Getting Started with Crucible", 
				slug: "crucible-getting-started",
				group: user.groups.find_by(name: "Feed"), 
				article_url: "",
				admin: user
			)

			instruction_article = Article.create(
				title: "Getting Started with Crucible", 
				author: "Crucible",
				date_published: Time.now,
				content: "crucible tutorial", 
				discussion: instruction_discussion
			)

			UsersGroupsUnreadDiscussion.create(user: user, group: instruction_discussion.group, discussion: instruction_discussion)				
			DiscussionUnreadMessage.create(user: user, discussion: instruction_discussion, unread_messages: 0)

			render json: { auth_token: command.result, user: {id: user.id, name: user.name_with_last_initial, email: user.email} }
		end
	end

	def feedback
		# binding.pry
		ApplicationMailer.send_feedback(@current_user, params[:feedback]).deliver_now
		render json: {message: "feedback successfully submitted"}
	end
end






