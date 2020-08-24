class ArticleInterest < ApplicationRecord
  belongs_to :article
  belongs_to :interest
end
