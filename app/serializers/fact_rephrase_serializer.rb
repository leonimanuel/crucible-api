class RephraseSerializer < ActiveModel::Serializer
  attributes :id, :content, :fact_id, :user_id
end
