class User < ApplicationRecord
	has_secure_password

	has_many :facts_users
	has_many :facts, through: :facts_users
	has_many :topics
	has_many :users_groups
	has_many :groups, through: :users_groups
	has_many :discussions, through: :groups
end
