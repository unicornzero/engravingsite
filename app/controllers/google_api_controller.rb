class GoogleApiController < ApplicationController
  
  helper_method :change_video_id_to_url

  def youtube
    @mysession = MyGoogleAPI.new
    @my_videos = @mysession.my_videos
  end

  def change_video_id_to_url(video_id)
    "http://www.youtube.com/watch?v=#{video_id}"
  end
end
