class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
      OAuth::Consumer.new("HwN77cVNj0z1GnnKOwDwQg", "FlLCias2JgxoHTtTNMRUOKGo1kKEsE4HsUeoFmPU",
      { :site=>"http://twitter.com",
        :authorize_url => "http://twitter.com/oauth/authenticate" })
    end
end