class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Login successful!"
        #redirect_back_or_default users_url
      else
        unless @user.oauth_token.nil?
          @user = User.find_by_oauth_token(@user.oauth_token)
          unless @user.nil?
            UserSession.create(@user)
            #InitializeUserSession(@user)
            session[:atoken] = @user.oauth_token
            session[:asecret] = @user.oauth_secret
            flash[:notice] = "Welcome back!"
            redirect_to users_url        
          else
            #redirect_back_or_default root_path
            #redirect_to users_url   
          end
        end
       # render :action => :new
      end
    end
    #redirect_to users_url 
    #return
  end
  
  def show
    @user = @current_user
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
