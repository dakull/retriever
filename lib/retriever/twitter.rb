require 'oauth/client/em_http'

module Retriever
  class Twitter
    attr_reader :rate_status
    # init twitter user and set acces_token, consumer
    # pentru care se vor prelua informatiile
    def initialize(tw_user,access_token,consumer)
      @twiter_user = tw_user
      @access_token = access_token
      @consumer = consumer
      @rate_status = 0
      @id_for_parsing = []
      @cursor = -1
      @no_of_gets = 0
    end
    
    
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids
    def get_followers_ids_fix
      req = EventMachine::HttpRequest.new("http://api.twitter.com/1/followers/ids.json?stringify_ids=true&screen_name=#{@twiter_user}&cursor=#{@cursor}").get(:head => {"Content-Type" => "application/x-www-form-urlencoded"}, 
                                      :timeout => -1) do |client|
        @consumer.sign!(client, @access_token)
      end
      
      req.callback {
        data = JSON.parse(req.response)
        @cursor = data['next_cursor']
        @id_for_parsing = @id_for_parsing | data['ids']
        p @id_for_parsing.length
        if @no_of_gets < 3
          get_followers_ids
          set_rate_status
          @no_of_gets += 1
        end
      }
      req.errback {
        # error
      }
    end      
    
    
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids
    def get_followers_ids
      req = EventMachine::HttpRequest.new("http://api.twitter.com/1/followers/ids.json?stringify_ids=true&screen_name=#{@twiter_user}&cursor=#{@cursor}").get
      oauth_helper = OAuth::Client::Helper.new(req, {:consumer => @consumer, :token => @access_token})
      req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
      req.callback {
        data = JSON.parse(req.response)
        @cursor = data['next_cursor']
        @id_for_parsing = @id_for_parsing | data['ids']
        p @id_for_parsing.length
        if @no_of_gets < 3
          get_followers_ids
          set_rate_status
          @no_of_gets += 1
        end
      }
      req.errback {
        # error
      }
    end     
    
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids
    def get_followers_ids
      req = EventMachine::HttpRequest.new("http://api.twitter.com/1/followers/ids.json?stringify_ids=true&screen_name=#{@twiter_user}&cursor=#{@cursor}").get
      oauth_helper = OAuth::Client::Helper.new(req, {:consumer => @consumer, :token => @access_token})
      req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
      req.callback {
        data = JSON.parse(req.response)
        @cursor = data['next_cursor']
        @id_for_parsing = @id_for_parsing | data['ids']
        p @id_for_parsing.length
        if @no_of_gets < 3
          get_followers_ids
          set_rate_status
          @no_of_gets += 1
        end
      }
      req.errback {
        # error
      }
    end   
    
    # get the IDs for every user the specified user is following
    # GET friends/ids
    #  - screen_name 
    #  - cursor
    #  - stringify_ids
    def get_friends_ids
      req = EventMachine::HttpRequest.new("http://api.twitter.com/1/friends/ids.json?screen_name=#{@twiter_user}&cursor=-1").get
      oauth_helper = OAuth::Client::Helper.new(req, {:consumer => @consumer, :token => @access_token})
      req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
      req.callback {
        data = JSON.parse(req.response)
        @id_for_parsing = @id_for_parsing | data['ids']
      }
      req.errback {
        # error
      }
    end
    
    # set rate no
    # GET rate_limit_status
    def set_rate_status
      req = EventMachine::HttpRequest.new('http://api.twitter.com/1/account/rate_limit_status.json').get
      oauth_helper = OAuth::Client::Helper.new(req, {:consumer => @consumer, :token => @access_token})
      req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
      req.callback {
        data = JSON.parse(req.response)
        @rate_status = data['remaining_hits']
        p "Ramaining: #{@rate_status}"
      }
      req.errback {
        # error
      }      
    end    
  end
end