json.array!(@groups) do |group|
  json.extract! group, :id, :name, :book_name, :page_number, :description, :start_date, :end_date
  json.url group_url(group, format: :json)
end
