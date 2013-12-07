require 'twitter'
require 'twitter_config'
require 'timeout'

class Api::TimelineController < ApplicationController
	after_filter :set_access_control_headers

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
		      	#puts "#{tweet.text}"
		      	tweet_count = tweet_count + 1
		      	collected_tweets["#{loop_time}"] = tweet_count
		      end
		    end
		  rescue Timeout::Error
		  	collected_tweets["#{loop_time}"] = tweet_count
		  	loop_count = loop_count + 1
		  	#puts "loop count: #{loop_count}, #{Time.now}"
		    next
		  end
		end
    render :json => collected_tweets
  end

  def heatmap
  	geocode = params[:geocode] || "37.776617,-122.417114,5000mi"
  	results = @twitter_client.search("chimeforchange", {:geocode => geocode, :count => 100})
  	geo_coordinates = results.map(&:geo)
  	geo_coordinates.reject! { |g| g.nil? }
  	coordinates = geo_coordinates.map(&:coordinates)
  	#binding.pry
  	places = results.map(&:place)
  	places.reject! { |p| p.nil? }
  	unless places.empty? 
  		boundaries = places.map(&:bounding_box)
  		if boundaries
	  		# TODO figure out how to get center
	  		more_coords = boundaries.map(&:coordinates)
	  		coordinates.zip(more_coords)#.flatten.compact if coordinates.present? && more_coords.present?
	  	end
  	end
  	render :json => coordinates
  end

  private

	def set_access_control_headers
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Request-Method'] = '*'

	end
  def client
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
    @twitter_streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  def find_center(bounding_box)
  	coords = bounding_box.coordinates

  end

end
