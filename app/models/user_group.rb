class UserGroup < ActiveRecord::Base
	belongs_to :user, :foreign_key => :user_id, :primary_key => :id
	belongs_to :group, :foreign_key => :group_id, :primary_key => :id
end
