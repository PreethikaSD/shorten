class Link < ApplicationRecord
	has_many :user_links
	has_many :users, :through => :user_links

	def self.get_short
		numbers = (1..9).to_a
		alphabets = ('a'..'z').to_a
		alphanumeric = numbers + alphabets
   		short_url=(0..10).map{ alphanumeric.to_a[rand(alphanumeric.size)] }.join
	end

end
