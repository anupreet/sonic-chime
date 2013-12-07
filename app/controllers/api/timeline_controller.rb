require 'twitter'
require 'twitter_config'
require 'timeout'

class Api::TimelineController < ApplicationController
  before_filter :client
  def interval
    collected_tweets = {}
		timeout_in_seconds = 1
		loop_count = 0
		interval = params[:interval] || 10
		loop_time = Time.now
		while loop_count < interval
		  begin
		  	tweet_count = 0
		  	loop_time = Time.now
		    Timeout::timeout(timeout_in_seconds) do
		      @twitter_streaming_client.filter(:track => "gaga") do |tweet|
		      	puts "#{tweet.text}"
		      	tweet_count = tweet_count + 1
		      	collected_tweets["#{loop_time}"] = tweet_count
		      end
		    end
		  rescue Timeout::Error
		  	collected_tweets["#{loop_time}"] = tweet_count
		  	loop_count = loop_count + 1
		  	puts "loop count: #{loop_count}, #{Time.now}"
		    next
		  end
		end
    render :json => collected_tweets
  end

  def heat_map
  	results = @twitter_client.search("gaga")
  	binding.pry
  end

  private

  def client
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TwitterConfig['consumer_key']
      config.consumer_secret     = TwitterConfig['consumer_secret']
      config.access_token        = TwitterConfig['access_token']
      config.access_token_secret = TwitterConfig['access_token_secret']
    end
    @twitter_streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = TwitterConfig['consumer_key']
      config.consumer_secret     = TwitterConfig['consumer_secret']
      config.access_token        = TwitterConfig['access_token']
      config.access_token_secret = TwitterConfig['access_token_secret']
    end
  end

end
