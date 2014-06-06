class AddPageNumberToComments < ActiveRecord::Migration
  def change
    add_column :comments, :page_number, :integer
  end
end
