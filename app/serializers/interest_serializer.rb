class InterestSerializer < ActiveModel::Serializer
  attributes :section, :title, :query, :selected

  def selected
  	if User.find(@instance_options[:current_user_id]).interests.include?(object)
  		true
		else
			false
  	end
  end
end
