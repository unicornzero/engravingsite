class FlickrStreamController < ApplicationController

  helper_method :pics_in_set
  before_filter :photoset_list, only: :main_stream

	require 'flickraw'
  FlickRaw.api_key= CONFIG[:flickraw_api]
  FlickRaw.shared_secret= CONFIG[:flickraw_secret]

  def main_stream
  end

  def user_stream
    @all_photos = flickr.people.getPublicPhotos(user_id: CONFIG[:my_flickr_id]).to_hash
  end



  def photoset_list
    @fid = CONFIG[:my_flickr_id]
    @psets = flickr.photosets.getList(user_id: @fid).to_hash["photoset"]
    @psets_hash = {}
    @psets.each { |s| 
      @psets_hash[s["id"]] = s["title"] }
  end

  def pics_in_set(set_id)
    @pics_response = flickr.photosets.getPhotos(photoset_id: set_id, privacy_filter: "1")
  end

end
