class ArticleRecommendation < ApplicationRecord
	has_many :article_rec_interests
	has_many :interests, through: :article_rec_interests
end
