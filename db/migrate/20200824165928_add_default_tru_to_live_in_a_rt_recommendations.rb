class AddDefaultTruToLiveInARtRecommendations < ActiveRecord::Migration[6.0]
  def change
  	change_column :article_recommendations, :live, :boolean, default: true 
  end
end
