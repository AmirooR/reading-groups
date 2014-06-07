class UserGroup < ActiveRecord::Base
	belongs_to :user, :foreign_key => :user_id, :primary_key => :id
	belongs_to :group, :foreign_key => :group_id, :primary_key => :id

	validates :num_read, numericality: {greater_than_or_equal_to: 0}
	validate :num_read_less_than_total_pages

	def num_read_less_than_total_pages
		unless group.present? && num_read <= group.page_number
			errors.add(:num_read, "^Read pages exceeds total number of books' pages")
		end
	end
end
