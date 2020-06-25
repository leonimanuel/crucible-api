class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :discussion_id, :user_id :created_at
end
