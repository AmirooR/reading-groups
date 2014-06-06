class Group < ActiveRecord::Base
	has_many :user_groups, dependent: :destroy
	has_many :users, :through => :user_groups
	
	has_many :comments

	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :book_name, presence: true
	validates :page_number, presence: true, numericality: { greater_than: 0}
	validates :description, presence: true, length: {maximum: 1000}
	validates :num_to_read, presence: true, numericality: { greater_than_or_equal_to: 0}
	validate :start_date_not_later_than_end_date
	validate :num_to_read_less_than_num_pages

	def start_date_not_later_than_end_date
		if start_date.past?
			errors.add(:start_date, "^Start date is in past!")
		end
		if start_date > end_date
			errors.add(:start_date, "^Start date cannot be later than end date")
		end
	end

	def num_to_read_less_than_num_pages
		if num_to_read > page_number
			errors.add(:num_to_read, "^Read to page number must be less than or equal to number of pages")
		end
	end
end
