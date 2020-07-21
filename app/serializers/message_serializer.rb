class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :discussion_id, :user_id, :message_type, :previous_el_id, :created_at
  belongs_to :user

  def user
  	{name: object.user.name, id: object.user.id}
  end
end
