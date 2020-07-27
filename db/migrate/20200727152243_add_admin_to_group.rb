class AddAdminToGroup < ActiveRecord::Migration[6.0]
  def change
  	add_column :groups, :admin_id, :integer
  end
end
