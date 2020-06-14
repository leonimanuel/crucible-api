class AddGroupIdToDiscussion < ActiveRecord::Migration[6.0]
  def change
  	add_reference :discussions, :group, index: true
  end
end
