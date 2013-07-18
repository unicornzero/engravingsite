class MyFlickrAPI

  require 'flickraw'
  attr_reader :sets_of_photos, :all_photos

  def initialize
    FlickRaw.api_key = CONFIG[:flickraw_api]
    FlickRaw.shared_secret = CONFIG[:flickraw_secret]
  end

  def load_main_stream
    find_photosets
    photo_list
  end

  def find_all_photos
    @all_photos = flickr.people.getPublicPhotos(user_id: CONFIG[:my_flickr_id]).to_hash
  end

    private
    def find_photosets
      @psets = flickr.photosets.getList(user_id: CONFIG[:my_flickr_id]).to_hash["photoset"]
    end

    def photo_list
      @sets_of_photos = @psets.map do |set|
        { 
          id: set["id"],
          title: set["title"],
          photos: photos_in_set(set["id"])
        }
      end
    end

    def photos_in_set(set_id)
      #@pics_response = flickr.photosets.getPhotos(photoset_id: set_id, privacy_filter: "1")
      @pics_response = flickr.photosets.getPhotos(photoset_id: set_id, privacy_filter: "1")["photo"]
    end

end