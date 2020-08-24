class Article < ApplicationRecord
	# belongs_to :discussion
	has_many :discussions

	has_many :article_interests
	has_many :interests, through: :article_interests
end
