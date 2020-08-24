class ArticleRecInterest < ApplicationRecord
  belongs_to :article_recommendation
  belongs_to :interest
end
