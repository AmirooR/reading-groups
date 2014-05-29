class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :book_name
      t.integer :page_number
      t.text :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
