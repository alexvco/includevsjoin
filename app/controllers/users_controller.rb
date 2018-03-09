class UsersController < ApplicationController
  def index
    # Display all users 
    #- @users = User.all

    # In our view we are displaying next to each user, the number of comments they have created, 
    # now if we just use @users = User.all, we will have n + 1 queries because in our view we have: user.comments.count
    # you can also use counter cache, but here we want to show how to do this via join query 
    @users = User.joins(:comments).select("users.*, COUNT(comments.id) AS comments_count").group("users.id")
    # @users = User.find_by_sql("SELECT users.*, COUNT(comments.id) AS comments_count FROM users INNER JOIN comments ON comments.user_id = users.id GROUP BY users.id;")
    # the query above creates like a virtual attribute comments_count in the user model and loads it into memory along with the user 
    # This is more efficient (obviously no n +1), because its performing everything in a single query instead of having to fetch the comments separately for every single user
    # This is another candidate for choosing the joins option over includes


    # irb(main):031:0> User.first
    # User Load (0.7ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
    # +----+----------+-------+-------------------------+-------------------------+
    # | id | name     | admin | created_at              | updated_at              |
    # +----+----------+-------+-------------------------+-------------------------+
    # | 1  | podjgvzb | true  | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC |
    # +----+----------+-------+-------------------------+-------------------------+
    # 1 row in set

    # irb(main):032:0> users = User.joins(:comments).select("users.*, COUNT(comments.id) AS comments_count").group("users.id")
    #   User Load (1.3ms)  SELECT users.*, COUNT(comments.id) AS comments_count FROM "users" INNER JOIN "comments" ON "comments"."user_id" = "users"."id" GROUP BY users.id
    # +----+----------+-------+-------------------------+-------------------------+----------------+
    # | id | name     | admin | created_at              | updated_at              | comments_count |
    # +----+----------+-------+-------------------------+-------------------------+----------------+
    # | 2  | cptwdvsl | true  | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 1              |
    # | 5  | eyucvstp | true  | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 2              |
    # | 6  | pruwsonx | false | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 3              |
    # | 4  | zshkatvc | true  | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 1              |
    # | 3  | fjvcuizh | false | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 2              |
    # | 9  | obmtqlka | true  | 2018-03-09 00:29:40 UTC | 2018-03-09 00:29:40 UTC | 1              |
    # +----+----------+-------+-------------------------+-------------------------+----------------+
    # 6 rows in set

    # irb(main):033:0> users = User.joins(:comments).select("users.name, COUNT(comments.id) AS esh").group("users.id")        
    #   User Load (1.4ms)  SELECT users.name, COUNT(comments.id) AS esh FROM "users" INNER JOIN "comments" ON "comments"."user_id" = "users"."id" GROUP BY users.id
    # +----+----------+-----+
    # | id | name     | esh |
    # +----+----------+-----+
    # |    | cptwdvsl | 1   |
    # |    | eyucvstp | 2   |
    # |    | pruwsonx | 3   |
    # |    | zshkatvc | 1   |
    # |    | fjvcuizh | 2   |
    # |    | obmtqlka | 1   |
    # +----+----------+-----+
    # 6 rows in set

  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to @user
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end
end
