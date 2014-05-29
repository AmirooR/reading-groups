class UserGroupsController < ApplicationController

  before_action :signed_in_user, only: [:create]
  def create
	user_group = current_user.user_groups.build( group_id: params[:group_id] )
	if user_group.save
		flash[:success] = "You successfully joined this group"
	else
		flash[:error] = "There was an error in joining this group"
	end 
	redirect_to groups_path
  end

  def destroy
	@user_group = UserGroup.find(params[:id])
	@user_group.destroy
	flash[:success] = "You successfully leaved the group."
	redirect_to groups_path
  end

private
	def signed_in_user
		unless signed_in?
			redirect_to signin_path, notice: "You should sign in first"
		end
	end
end
