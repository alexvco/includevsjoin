class CommentsController < ApplicationController
  def index
    # Display all comments
    #- @comments = Comment.all

    # Display all comments that are created by (belong_to) users who are admin (admin is a boolean column in the users table)
    # We are filtering the comments based on an attribute from the users table


    # JOINS

    #- @comments = Comment.joins(:user).where(users: {admin: true}).all
          # Comment.find_by_sql("Select * FROM comments INNER JOIN users ON users.id = comments.user_id WHERE users.admin = 't';")
    # with this query the users attributes were not selected/loaded in to memory with the above query (hence n + 1 is still an issue with this query)


    # INCLUDES

    # Same query but using includes instead of joins, 
    # this fetches alot of different columns from both the comments table and the users table at the same time, 
    # basically creating the user models in memory at the same time as its fetching the comments
     @comments = Comment.includes(:user).where(users: {admin: true}).all
          # @comments = ActiveRecord::Base.connection.execute("SELECT comments.id AS t0_r0, comments.content AS t0_r1, comments.user_id AS t0_r2, comments.created_at AS t0_r3, comments.updated_at AS t0_r4, users.id AS t1_r0, users.name AS t1_r1, users.admin AS t1_r2, users.created_at AS t1_r3, users.updated_at AS t1_r4 FROM comments LEFT OUTER JOIN users ON users.id = comments.user_id WHERE users.admin = 't';").to_a
          # the above query does not return an active record relation or active record object but a PG::Result. You can then convert this to an array (it is technically an array of hashes: key-value pairs, the issue is you cant chain other activerecord methods to it nor access it as an object)
          # with this query (n + 1) is eliminated as all the attributes of the user is already in memory. The includes method already loaded up the models, associated models and attributes at that same time.
          # Note that you are doing a left outer join with this query as opposed to an inner join


    # The key question to ask is, Am I using any of the user associated attributes (such as user.name) on this page
      # If yes, then you should use includes
      # If not, lets say you just want to filter/show the comments created by users who are admin but dont need to display their name or any of their attributes. In that case its better to use joins because you dont want to unnecessarily load all the user attributes into memory.

  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @comment
    else
      render :action => 'new'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end
end
