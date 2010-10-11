require "pathname"
require "cgi"
require "openid"

class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create,:show]
  #before_filter :require_user, :only => [ :edit, :update]

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
        flash[:error] = @user.errors.full_messages
        debugger
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
           #flash[:error] = @user.errors.full_messages
           redirect_to users_url   
          end
        end
      #end
       # render :action => :new
     end
    end
    #redirect_to users_url 
    #return
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
  
  def openidlogin
    #debugger
    identity_url = params[:open_id_url]
    authenticate_with_open_id(identity_url,
            :required => [:email,:fullname ]) do |result, identity_url, registration|
          case result.status
          when :missing
            failed_login "Sorry, the OpenID server couldn't be found"
          when :invalid
            failed_login "Sorry, but this does not appear to be a valid OpenID"
          when :canceled
            failed_login "OpenID verification was canceled"
          when :failed
            failed_login "Sorry, the OpenID verification failed"
          when :successful
            if @current_user = User.find_by_openid_url(identity_url)
              #assign_registration_attributes!(registration)
              UserSession.create(@current_user)

              if current_user.save
                successful_login
                return
              else
                failed_login "Your OpenID profile registration failed: " +
                  @current_user.errors.full_messages.to_sentence
              end
            else
              @current_user = User.new
              #debugger
              #assign_registration_attributes!(registration)
              @current_user.openid_url = identity_url
              @current_user.persistence_token = "asdfasfsad"
              @current_user.fullname = registration["fullname"]
              @current_user.login = registration["fullname"]
              @current_user.email = registration["email"]
              @current_user.save do |result|
                if result
                  UserSession.create(@current_user)
                  successful_login
                  return
                else
                  failed_login "Sorry, no user by that identity URL exists" +
                  @current_user.errors.full_messages.to_sentence
                  return
                end
                
              end
              redirect_to(root_url)
              return
              #failed_login "Sorry, no user by that identity URL exists"
            end
          end
        end
        #redirect_to(root_url)
  end

    private
      # registration is a hash containing the valid sreg keys given above
      # use this to map them to fields of your user model
      def assign_registration_attributes!(registration)
        model_to_registration_mapping.each do |model_attribute, registration_attribute|
          unless registration[registration_attribute].blank?
            @current_user.send("#{model_attribute}=", registration[registration_attribute])
          end
        end
      end

      def model_to_registration_mapping
        { :login => 'nickname', :email => 'email', :display_name => 'fullname' }
      end
    
      def successful_login
        session[:user_id] = @current_user.id
        redirect_to(root_url)
      end

      def failed_login(message)
        flash[:error] = message
        redirect_to(new_user_url)
      end
  
end
