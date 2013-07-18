class FlickrStreamController < ApplicationController

  def main_stream
    @flickr = MyFlickrAPI.new
    @flickr.load_main_stream
    @sets_of_photos = @flickr.sets_of_photos
  end

  def user_stream
    @flickr = MyFlickrAPI.new
    @flickr.find_all_photos
    @all_photos = @flickr.all_photos
  end

end
