class FlickrStreamController < ApplicationController

require 'flickraw'

FlickRaw.api_key= CONFIG[:flickraw_api]
FlickRaw.shared_secret= CONFIG[:flickraw_secret]

list   = flickr.photos.getRecent

id     = list[0].id
secret = list[0].secret
info = flickr.photos.getInfo :photo_id => id, :secret => secret

puts info.title           # => "PICT986"
puts info.dates.taken     # => "2006-07-06 15:16:18"

sizes = flickr.photos.getSizes :photo_id => id

original = sizes.find {|s| s.label == 'Original' }
puts original.width       # => "800" -- may fail if they have no original marked image

  def main_stream
    @info = flickr.photos.getInfo(:photo_id => "3839885270")
    @url = FlickRaw.url_photostream(@info) # => "http://www.flickr.com/photos/41650587@N02/"
  end
end
