class Comment < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :page_number, numericality: { greater_than: 0 }
  validate  :page_number_less_than_total_pages

  def page_number_less_than_total_pages
	unless group.present? && page_number <= group.page_number
		errors.add(:page_number, '^Comment page number exceeds book number of pages!')
	end
  end
end
