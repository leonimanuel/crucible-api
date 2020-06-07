class User < ApplicationRecord
	has_secure_password

	has_many :facts_users
	has_many :facts, through: :facts_users
end
