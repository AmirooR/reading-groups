class CommentsController < ApplicationController
  #before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :correct_group_user, only: [:edit, :update, :destroy, :create, :new]
  before_action :correct_commenter, only: [:update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    if params.has_key?(:group_id)
	@group = Group.find(params[:group_id])
	@comments = @group.comments
    else
    	@comments = Comment.all
    end
  end

  def bookpage
	if params.has_key?(:group_id) && params.has_key?(:bookpage)
		group = Group.find(params[:group_id])
		@current_comment_page = params[:bookpage]
		@comments = group.comments.where( 'page_number in (?)',params[:bookpage] )
		@comment = group.comments.build
	else
		redirect_to groups_path, notice: "How did you get there?"
	end
  end
  # GET /comments/1
  # GET /comments/1.json
  def show
	if params.has_key?(:group_id)
		group = Group.find(params[:group_id])
		@comment = group.comments.find( params[:id] )
	else
		@comment = Comment.find( params[:id] )
	end
  end

  # GET /comments/new
  def new
	if params.has_key?(:group_id)
		group = Group.find(params[:group_id])
		@comment = group.comments.build
	else
		@comment = Comment.new
	end
  end

  # GET /comments/1/edit
  def edit
	group = Group.find(params[:group_id])
	@comment = group.comments.find(params[:id])	
  end

  # POST /comments
  # POST /comments.json
  def create
    group = Group.find(params[:group_id])
    @comment = group.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@comment.group, @comment], notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    group = Group.find( params[:group_id] )
    @comment = group.comments.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to [@comment.group, @comment], notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    group = Group.find( params[:group_id] )
    @comment = group.comments.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted successfully"
    respond_to do |format|
      format.html { redirect_to group_comments_url }
      format.json { head :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:title, :body , :user_id, :page_number)
    end

    def correct_group_user
	unless signed_in?
		store_location
		redirect_to signin_url, notice: "Please sign in."
		return
	end

	if params.has_key?(:group_id)
		unless current_user.group_ids.include? params[:group_id].to_i
			store_location
			redirect_to group_path(params[:group_id]), notice: "You must be a member of this group first"
			return
		end
        else
		redirect_to user_path(current_user), notice: "Wrong path!" 
	end

    end

    def correct_commenter
	group = Group.find( params[:group_id] )
    	@comment = group.comments.find(params[:id])
	unless @comment.user_id == current_user.id
		redirect_to group_path(group.id), notice: "You are not allowed to do that"
	end
    end

end
