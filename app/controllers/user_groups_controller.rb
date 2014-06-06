class UserGroupsController < ApplicationController

  before_action :signed_in_user, only: [:create]
  def edit
	@user_group = UserGroup.find(params[:id])
  end

  def update
	@user_group = UserGroup.find(params[:id])
	respond_to do |format|
		if @user_group.update_attributes(user_group_params)
			flash[:success] = "Your membership updated"
			format.html { redirect_to group_path(@user_group.group_id) }
			format.json { head :ok }
		else
			format.html {render 'edit' }
			format.json {render json: @user_group.errors, status: :unprocessible_entity }
		end
	end
  end
  
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

	def user_group_params
		params.require(:user_group).permit(:num_read)
	end
end
