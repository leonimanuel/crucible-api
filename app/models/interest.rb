class Interest < ApplicationRecord
	has_many :users_interests
	has_many :users, through: :users_interests

	has_many :interests_briefings
  has_many :briefings, through: :interests_briefings	

	has_many :article_interests
	has_many :articles, through: :article_interests

	has_many :article_rec_interests
	has_many :article_recommendations, through: :article_rec_interests	
end
