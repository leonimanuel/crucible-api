class AddArticleIdToDiscussions < ActiveRecord::Migration[6.0]
  def change
  	 add_column :discussions, :article_id, :integer
  end
end
