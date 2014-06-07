require "will_paginate/array"

class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy, :create]
  before_action :admin_user_for_group, only: [:edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
	if params.has_key?(:search)
		@groups = Group.search(params[:search]).paginate(page: params[:page], per_page: 10)
	else
    		@groups = Group.paginate(page: params[:page], per_page: 10) #order: 'name ASC'
	end
	#respond_to do |format|
	#	format.js {}
	#	format.html {}
	#end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
	current_page = 1
	if params[:page]
		 current_page =  params[:page]
	end
	per_page = 10
		
	@group_users = WillPaginate::Collection.create(  current_page, per_page, @group.users.length) do |pager|
		pager.replace @group.users
	end

	#@comment = @group.comments.build

	@top_comments = @group.comments.order(created_at: :desc)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.admin_id = current_user.id
    respond_to do |format|
      if @group.save
	UserGroup.create(admin: true, user_id: current_user.id, group_id: @group.id)
	flash[:success] = "Group was successfully created!"
        format.html { redirect_to @group }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      flash[:success] = "Group successfully deleted"
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :book_name, :page_number, :description, :start_date, :end_date, :num_to_read)
    end

    def signed_in_user
	unless signed_in?
		store_location
		redirect_to signin_url, notice: "You must sign in to do that!"
	end
    end

    def admin_user_for_group
	am_i_admin = UserGroup.where('user_id in (?) and group_id in (?) and admin in (?)', current_user.id, @group.id, true)
	unless am_i_admin.any?
		store_location
		redirect_to user_path(current_user), notice: "You are not allowed to do that!"
	end
    end
end
