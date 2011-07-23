module Retriever
  class Twitter
    # init twitter user and set acces_token, consumer
    # pentru care se vor prelua informatiile
    def initialize(tw_user,access_token,consumer)
      @twiter_user = tw_user
      @access_token = access_token
      @consumer = consumer
    end
    
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids 
    def get_rate_status
      req = EventMachine::HttpRequest.new('http://api.twitter.com/1/account/rate_limit_status.json').get
      oauth_helper = OAuth::Client::Helper.new(req, {:consumer => @consumer, :token => @access_token})
      req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
      req.callback {
        p req.response
      }
    end
    
  end
end