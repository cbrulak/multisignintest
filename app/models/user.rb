
# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  acts_as_authentic do |c| 
    c.validate_login_field = false
    c.validate_password_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
  end
  
  before_create :populate_oauth_user 
 
  private

  def populate_oauth_user
    unless oauth_token.blank?
      debugger
      @response = UserSession.oauth_consumer.request(:get, '/account/verify_credentials.json',
      access_token, { :scheme => :query_string })
      case @response
      when Net::HTTPSuccess
        user_info = JSON.parse(@response.body)
        
        self.login = user_info['screen_name']
        #self.username = user_info['screen_name']
        #self.twitter = user_info['screen_name']
        #if(self.username.nil?)
         # self.username = "username is empty" +  self.fullname
        #end
        #self.avatar_url  = user_info['profile_image_url']
      end
    end
  end


  def self.get(openid_url)
    find_first(["openid_url = ?", openid_url])
  end  
  

  protected
  
  validates_uniqueness_of :openid_url, :on => :create
  #validates_presence_of :openid_url
end
