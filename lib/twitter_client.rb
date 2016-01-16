require 'twitter'

class TwitterClient < Twitter::REST::Client
  def initialize(keys = {})
    self.consumer_key        = keys['consumer_key']
    self.consumer_secret     = keys['consumer_secret']
    self.access_token        = keys['access_token']
    self.access_token_secret = keys['access_token_secret']
  end
end
