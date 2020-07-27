class AddAdminToDiscussions < ActiveRecord::Migration[6.0]
  def change
  	add_column :discussions, :admin_id, :integer
  end
end
