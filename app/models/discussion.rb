class Discussion < ApplicationRecord
	belongs_to :group

	has_one :article
	# has_one :from
	has_many :comments
end
