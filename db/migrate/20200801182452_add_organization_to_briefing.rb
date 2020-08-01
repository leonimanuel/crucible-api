class AddOrganizationToBriefing < ActiveRecord::Migration[6.0]
  def change
  	add_column :briefings, :organization, :string
  end
end
