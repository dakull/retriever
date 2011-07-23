require 'rubygems'
require 'oauth'
require 'em-http-oauth-request'
require 'json'

EventMachine.run {

  # oauth part
  consumer = OAuth::Consumer.new('4U5nXir2XPcL9DcHFxREQ', 'SzINDCRCUT31O4YCisFhnMPdgeNaQRSWlVUlDGeA', :site => 'https://api.twitter.com')
  atoken = '16558673-4d72pMdrnRFNxENDHC4xJwPF7QxOgCH6GhmgZPat8'
  asecret = '6pTN82arExtor1vfxWD32LHB05O8fSwNPVpNjXvHU'
  access_token = OAuth::AccessToken.new(consumer, atoken, asecret)
  oauth_params = {:consumer => consumer, :token => access_token}
  
  # make request 01
  req = EventMachine::HttpRequest.new('http://api.twitter.com/1/account/rate_limit_status.json').get
  oauth_helper = OAuth::Client::Helper.new(req, oauth_params)


  req.options[:head] = (req.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
  req.callback {
    p req.response
    #EventMachine.stop
  }
  
  # make request 02
  req2 = EventMachine::HttpRequest.new('http://api.twitter.com/1/account/rate_limit_status.json').get
  oauth_helper = OAuth::Client::Helper.new(req2, oauth_params)

  req2.options[:head] = (req2.options[:head] || {}).merge!({"Authorization" => oauth_helper.header})
  req2.callback {
    p req2.response
    EventMachine.stop
  }  
}

p 'END'