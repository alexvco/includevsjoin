class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])

    # Now lets say I want to display all the comments which are made by users that belong to a specific group
        # We can do this in 2 queries 
        # @users = @group.users
        # @comments = @users.comments

        # rails does not support nested has_many associations: so you cant do this in your model
        # class Group < ApplicationRecord
        #   has_many :memberships
        #   has_many :users, :through => :memberships
        #   # has_many :comments, :through => :users # Rails does not support nested has_many associations
        # end

        # we need to find a way to do this nested has_many association, 
        # we can do this with joins, which allows us to get the comments with 1 single query
        @comments = Comment.joins({user: :memberships}).where(memberships: {group_id: @group.id})
        # @comments = Comment.find_by_sql("SELECT comments.* FROM comments INNER JOIN users ON users.id = comments.user_id INNER JOIN memberships ON memberships.user_id = users.id WHERE memberships.group_id = #{@group.id};")





        # Post.joins(:category, :comments)
        # Returns all posts that have a category and at least one comment
        # If you're joining nested tables you can list them as in a hash:

        # Post.joins(:comments => :guest)
        # Returns all comments made by a guest
        # Nested associations, multiple level:

        # Category.joins(:posts => [{:comments => :guest}, :tags])
        # Returns all posts with their comments where the post has at least one comment made by a guest
        # You can also chain ActiveRecord Query Interface calls such that:

        # Post.joins(:category, :comments)
        # ...produces the same SQL as...
        # Post.joins(:category).joins(:comments)

  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "Successfully created group."
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to @group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "Successfully destroyed group."
    redirect_to groups_url
  end
end
