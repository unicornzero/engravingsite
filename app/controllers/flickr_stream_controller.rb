class FlickrStreamController < ApplicationController

	require 'flickraw'
  FlickRaw.api_key= CONFIG[:flickraw_api]
  FlickRaw.shared_secret= CONFIG[:flickraw_secret]

  def main_stream
  	user_lookup
    photoset_list
  end

  private
  	def user_lookup
	    @fname = CONFIG[:my_flickr_user]
	    @fuser = flickr.people.findByUsername(:username => @fname)
	    @fuser_hash= @fuser.to_hash
      @fuser_name = @fuser_hash["username"]
  	end

    def photoset_list
      @fid = CONFIG[:my_flickr_id]
      @plist = flickr.photosets.getList(user_id: @fid)
      @psetlist = @plist.to_hash
      @psets = @psetlist["photoset"]
      @psets_hash = []

      @psets.each {|s| @psets_hash << s["title"]}
    end
end
