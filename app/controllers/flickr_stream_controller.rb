class FlickrStreamController < ApplicationController

require 'flickraw'


  def main_stream
    FlickRaw.api_key= CONFIG[:flickraw_api]
    FlickRaw.shared_secret= CONFIG[:flickraw_secret]
    @fname = CONFIG[:my_flickr_user]
    @fuser = flickr.people.findByUsername(:username => @fname)
    @fuser_hash= @fuser.to_hash
    @fuser_name = @fuser_hash["username"]
  end
end
