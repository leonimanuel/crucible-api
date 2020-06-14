class Add < ActiveRecord::Migration[6.0]
  def change
  	add_column :discussions, :article_url, :text
  end
end
