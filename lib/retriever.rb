$LOAD_PATH << File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'rubygems'
require 'oauth'
require 'em-http-oauth-request'
require 'json'

require 'retriever/twitter'
require 'retriever/oauth'

module Retriever
  VERSION = "0.0.1"
end

