class AddGradeToReviewColumns < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :grade, :float
  	add_column :fact_rephrases, :grade, :float
  	add_column :comments, :grade, :float
  	add_column :facts_comments, :grade, :float
  end
end
