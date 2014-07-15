class UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:destroy, :update, :edit]
  before_action :signed_in_user, only: [:create, :edit, :update, :destroy, :modal]
  before_action :correct_group_user, only: [:edit,:update,:destroy]

  def edit
  end

  def update
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
	@user_group.destroy
	flash[:success] = "You successfully leaved the group."
	redirect_to groups_path
  end

  def modal
	user_group = UserGroup.find( params[:user_group_id] )
	group = Group.find(user_group.group_id)
	bookpage = Integer(params[:bookpage])

	if bookpage < 0 || bookpage > group.page_number
		flash[:error] = "Invalid number of read pages!"
		redirect_to group
	end

	if params[:todo] == "read"
		user_group.update_attributes( num_read: bookpage )
		flash[:success] = "Membership update (number of read pages: " + params[:bookpage] + ")"
		redirect_to group

	elsif params[:todo] == "comments"
		redirect_to page_group_comments_url(group_id: user_group.group_id, bookpage: bookpage )

	elsif params[:todo] == "milestone"
		group.update_attributes( :num_to_read=>bookpage , :end_date=>Date.new(Integer(params[:end_date][:year]),Integer(params[:end_date][:month]), Integer(params[:end_date][:day])) )
		if group.valid?
			flash[:success] = "Group milestone updated successfully"
		else
			flash[:error] = group.errors.messages.first[1][0]
		end
		redirect_to group
	end
	#flash[:success] = params[:bookpage] + ', action: ' + params[:todo]
	#redirect_to groups_path
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

	def set_user_group
		@user_group = UserGroup.find(params[:id])
	end

        def correct_group_user
		unless current_user.id == @user_group.user_id
			redirect_to group_path(@user_group.group_id), notice: "You are not allowed to do that"
		end
	end
end
