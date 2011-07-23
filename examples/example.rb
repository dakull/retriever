$LOAD_PATH << '../lib'

require 'retriever'

p Retriever::VERSION

oauth_options = { 
                  :consumer_key => '4U5nXir2XPcL9DcHFxREQ',
                  :consumer_secret => 'SzINDCRCUT31O4YCisFhnMPdgeNaQRSWlVUlDGeA',
                  :access_token => '16558673-4d72pMdrnRFNxENDHC4xJwPF7QxOgCH6GhmgZPat8',
                  :access_secret => '6pTN82arExtor1vfxWD32LHB05O8fSwNPVpNjXvHU',
                  :site => 'http://api.twitter.com'
                }

atc = Retriever::OAuthClient.new oauth_options
twitter_api_client = Retriever::Twitter.new 'aplusk', atc

# EM
EM.run {
  twitter_api_client.set_rate_status
  twitter_api_client.get_friends_ids
  #twitter_api.get_followers_ids
  #twitter_api.set_rate_status
}


sorted = twitter_api_client.users_data.sort_by { |item| item[:statuses_count] }.reverse

sorted.each do |user| 
  puts "No. of followers: #{user[:statuses_count]} | No. of friends: #{user[:friends_count]} | User name: #{user[:screen_name]}"
end





