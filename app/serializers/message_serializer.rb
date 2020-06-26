class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :discussion_id, :user_id, :created_at
  belongs_to :user

  def user
  	object.user.name
  end
end
