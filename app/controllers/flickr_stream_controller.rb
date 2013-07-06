class FlickrStreamController < ApplicationController

	require 'flickraw'
  FlickRaw.api_key= CONFIG[:flickraw_api]
  FlickRaw.shared_secret= CONFIG[:flickraw_secret]

  def main_stream
  	user_lookup
    @fuser_name = @fuser_hash["username"]
  end

  private
  	def user_lookup
	    @fname = CONFIG[:my_flickr_user]
	    @fuser = flickr.people.findByUsername(:username => @fname)
	    @fuser_hash= @fuser.to_hash
  	end
end
