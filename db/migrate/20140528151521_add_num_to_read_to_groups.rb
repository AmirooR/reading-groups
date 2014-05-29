class AddNumToReadToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :num_to_read, :integer, default: 0
  end
end
