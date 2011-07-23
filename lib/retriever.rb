$LOAD_PATH << File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'rubygems'
require 'oauth'
require 'oauth/client/em_http'
require 'json'

require 'customlogger/customlogger'
require 'retriever/twitter'
require 'retriever/oauth'

module Retriever
  VERSION = "0.0.1"
end

