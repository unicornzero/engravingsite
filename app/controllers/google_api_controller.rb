class GoogleApiController < ApplicationController
  
  require 'google/api_client'

  helper_method :change_video_id_to_url


  ### Variables ###
  # Config hash values defined in config/application.yml:
  GOOGLE_DEV_KEY = CONFIG[:google_api_key]
  GOOGLE_PRIVATE_KEY_PATH = "#{Rails.root}/config/privatekey/#{CONFIG[:google_private_key]}"
  GOOGLE_KEY_PASSWORD = CONFIG[:google_key_password]  
  GOOGLE_ISSUER = CONFIG[:google_issuer]

  # Standard YouTube data:
  YOUTUBE_API_SERVICE_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"
  YOUTUBE_READONLY_SCOPE = 'https://www.googleapis.com/auth/youtube.readonly'

  # Editable application-specific data:
  YOUTUBE_USERS = ["dumarsengraving", "jaydumars"]
  MY_APP_NAME = "Engraver App"
  MY_APP_VER = "v1"


  def youtube
    start_session
    #find_user_uploads_playlist
    find_videos_in_uploads_playlist
  end


  def start_session
    @client = Google::APIClient.new(key: GOOGLE_DEV_KEY, authorization: nil, application_name: MY_APP_NAME, application_version: MY_APP_VER)
    @youtube_api = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    key = Google::APIClient::PKCS12.load_key(GOOGLE_PRIVATE_KEY_PATH, GOOGLE_KEY_PASSWORD)
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => YOUTUBE_READONLY_SCOPE,
      :issuer => GOOGLE_ISSUER,
      :signing_key => key)
    @client.authorization.fetch_access_token!
  end

  def find_user_uploads_playlist
    @result = @client.execute!(
      :api_method => @youtube_api.channels.list,
      :parameters => { part: 'contentDetails', forUsername: "jaydumars"} )
    @user_uploads = @result.data.items.first["contentDetails"]["relatedPlaylists"]["uploads"]
  end

  def find_videos_in_uploads_playlist
    @video_list_response = @client.execute!(
      :api_method => @youtube_api.playlist_items.list,
      # snake_case playlist_items due to https://code.google.com/p/google-api-ruby-client/issues/detail?id=64
      :parameters => { 
        part: "snippet", 
        playlistId: "UUu-3OECrvptij7cGs_A9Bqg",
        maxResults: 50 } )

    @video_results = {}
    @video_list_response.data.items.each do |playlist_item|
        title = playlist_item['snippet']['title']
        video_id = playlist_item['snippet']['resourceId']['videoId']
        @video_results[video_id] = title
      end
  end

  def change_video_id_to_url(video_id)
    "http://www.youtube.com/watch?v=#{video_id}"
  end


end
