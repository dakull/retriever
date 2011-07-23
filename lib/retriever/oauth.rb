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
    attr_reader :consumer, :access_token
    # init optiunile 
    # TODO verificat daca sunt ok
    def initialize(options={})
      @options = options
      gen_access_token
    end
    
    private
    # return acces_token
    def gen_access_token
      @consumer = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret], :site => @options[:site])
      @access_token = OAuth::AccessToken.new(consumer, @options[:access_token], @options[:access_secret])
    end
  end
end