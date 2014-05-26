module ApplicationHelper
	def full_title(page_title)
		base_title = "Reading Groups"
		if page_title.empty?
			base_title
		else
			"#{base_tile} | #{page_title}"
		end
	end
end
