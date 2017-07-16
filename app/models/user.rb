class User < ApplicationRecord
	has_many :user_links
	has_many :links, :through => :user_links
end
