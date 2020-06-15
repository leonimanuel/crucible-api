class AddDiscussionToArticle < ActiveRecord::Migration[6.0]
  def change
  	add_reference :articles, :discussion, index: true
  end
end
