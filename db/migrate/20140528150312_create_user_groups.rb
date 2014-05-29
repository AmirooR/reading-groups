class CreateUserGroups < ActiveRecord::Migration
  def change
    #drop_table :user_groups
    create_table :user_groups do |t|
      t.integer :num_read, default: 0
      t.boolean :admin, default: false
      t.belongs_to :user, null: false
      t.belongs_to :group, null: false
      t.timestamps
    end
  end
end
