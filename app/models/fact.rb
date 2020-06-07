class Fact < ApplicationRecord
	has_many :facts_users
	has_many :users, through: :facts_users
end
