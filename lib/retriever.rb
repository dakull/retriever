$LOAD_PATH << File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'retriever/twitter'

module Retriever
  VERSION = "0.0.1"
end

