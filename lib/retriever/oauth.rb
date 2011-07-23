#
# @options hash: 
#   - consumer_key
#   - consumer_secret
#   - access_token
#   - access_secret
#   - site
#
module Retriever
  class OAuthClient
    attr_reader :consumer, :access_token, :site
    # init optiunile 
    # TODO verificat daca sunt ok
    def initialize(options={})
      @options = options
      @site = @options[:site]
      gen_access_token
    end
    
    # make request
    def make_request(site)
      EventMachine::HttpRequest.new(site).get(:head => {"Content-Type" => "application/x-www-form-urlencoded"} , :timeout => -1) do |client|
        @consumer.sign!(client, @access_token)
      end
    end
    
    private
    # return acces_token
    def gen_access_token
      @consumer = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret], :site => @options[:site])
      @access_token = OAuth::AccessToken.new(consumer, @options[:access_token], @options[:access_secret])
    end
  end
end