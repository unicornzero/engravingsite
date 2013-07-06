class FlickrStreamController < ApplicationController

require 'flickraw'
FlickRaw.api_key= CONFIG[:flickraw_api]
FlickRaw.shared_secret= CONFIG[:flickraw_secret]

  def main_stream
    @info = flickr.photos.getInfo(:photo_id => "3839885270")
    @url = FlickRaw.url_photostream(@info) # => "http://www.flickr.com/photos/41650587@N02/"
  end
end
