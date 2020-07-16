class ChangeLegitimacyToCredibilityInFacts < ActiveRecord::Migration[6.0]
  def change
  	rename_column :facts, :legitimacy_upvotes, :credibility_upvotes
  	rename_column :facts, :legitimacy_downvotes, :credibility_downvotes
  end
end
