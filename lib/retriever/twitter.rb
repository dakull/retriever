module Retriever
  class Twitter
    include CustomLogger
    attr_reader :rate_status, :id_for_parsing, :users_data
    # init twitter user and set acces_token, consumer
    # pentru care se vor prelua informatiile
    def initialize(tw_user,atc)
      @twiter_user = tw_user
      @oauth_client = atc
      @id_for_parsing = []
      @users_data = []      
      @rate_status = 0
      @cursor = -1
      @no_of_gets = 0
    end
    
    # get the user info for max 100 ids
    # GET users/lookup
    #  - screen_name
    #  - user_id
    def lookup_users_id
      # get 99 user ids
      p "Toti: #{@id_for_parsing.length}"
      users = @id_for_parsing.pop(99)
      
      site = "#{@oauth_client.site}/1/users/lookup.json?user_id=#{users.join(",")}"
      p site
      req = @oauth_client.make_request site
      
      req.callback {
        data = JSON.parse(req.response)
        # pentru manipulare mai simpla
        data.each do |user|
          buff = {
                  :id => user['id'],  
                  :screen_name => user['screen_name'],
                  :statuses_count => user['statuses_count'],
                  :friends_count => user['friends_count']
                 }
          @users_data << buff
        end
        # face pentru urmatorii
        set_rate_status
        if @rate_status > 1 && @id_for_parsing.length > 1
          lookup_users_id
        else
          EM.stop
        end
      }
      req.errback {
        log_error req.error
      }
    end
    
    # get the IDs for every user follower
    # GET followers/ids
    #  - screen_name
    #  - cursor
    #  - stringify_ids
    def get_followers_ids
      site = "#{@oauth_client.site}/1/followers/ids.json?stringify_ids=true&screen_name=#{@twiter_user}&cursor=#{@cursor}"
      req = @oauth_client.make_request site
      
      req.callback {
        data = JSON.parse(req.response)
        @cursor = data['next_cursor']
        @id_for_parsing = @id_for_parsing | data['ids']
        p @id_for_parsing.length
        if @no_of_gets < 2
          get_followers_ids
          set_rate_status
          @no_of_gets += 1
        else
          set_rate_status
          if @rate_status > 1
            lookup_users_id
          end
        end  
      }
      req.errback {
        log_error req.error
      }
    end      
        
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids
    def get_friends_ids
      site = "#{@oauth_client.site}/1/friends/ids.json?screen_name=#{@twiter_user}&cursor=-1"
      req = @oauth_client.make_request site

      req.callback {
        data = JSON.parse(req.response)
        @id_for_parsing = @id_for_parsing | data['ids']

        set_rate_status
        if @rate_status > 1
          lookup_users_id
        end
      }
      req.errback {
        log_error req.error
      }
    end
    
    # set rate no
    # GET rate_limit_status
    def set_rate_status
      site = "#{@oauth_client.site}/1/account/rate_limit_status.json"
      req = @oauth_client.make_request site
      
      req.callback {
        data = JSON.parse(req.response)
        @rate_status = data['remaining_hits']
        p "Ramaining: #{@rate_status}"
      }
      req.errback {
        log_error req.error
      }      
    end    
  end
end