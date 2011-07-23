$LOAD_PATH << '../lib'

require 'retriever'

p Retriever::VERSION

oauth_options = { :consumer_key => '4U5nXir2XPcL9DcHFxREQ',
                  :consumer_secret => 'SzINDCRCUT31O4YCisFhnMPdgeNaQRSWlVUlDGeA',
                  :access_token => '16558673-4d72pMdrnRFNxENDHC4xJwPF7QxOgCH6GhmgZPat8',
                  :access_secret => '6pTN82arExtor1vfxWD32LHB05O8fSwNPVpNjXvHU',
                  :site => 'https://api.twitter.com'
                 }

atc = Retriever::OAuthClient.new oauth_options

twitter_api = Retriever::Twitter.new 'aplusk', atc.access_token, atc.consumer

# EM
EM.run {
  twitter_api.get_rate_status
  #EM.stop
}

