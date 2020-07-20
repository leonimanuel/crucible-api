class FactSerializer < ActiveModel::Serializer
	attributes :id, :content, :rephrase, :logic_upvotes, :logic_downvotes, :context_upvotes, :context_downvotes, :credibility_upvotes, :credibility_downvotes, :review_status, :topic_id

	def rephrase
		object.fact_rephrases.where(user_id: @instance_options[:current_user_id]).last
	end

  def topic_id
  	TopicsFact.where(topic: Topic.where(user_id: @instance_options[:current_user_id]).map {|t| t.id }).where(fact_id: object.id).first.topic_id
  end
end



# class FactSerializer
# 	def initialize(topic_object)
# 		@topic = topic_object
# 	end

# 	def to_serialized_json
# 		options = {
# 			include: {
# 				topics: {
# 					except: [:user_id]
# 				}
# 			}
# 		}
# 		# binding.pry
# 		@topic.to_json(options)
# 	end
# end