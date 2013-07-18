class MyGoogleAPI
  
  require 'google/api_client'



  ### Variables ###
  # Config hash values defined in config/application.yml:
  #GOOGLE_DEV_KEY = CONFIG[:google_api_key]
  #GOOGLE_PRIVATE_KEY_PATH = "#{Rails.root}/config/privatekey/#{CONFIG[:google_private_key]}"
  #GOOGLE_KEY_PASSWORD = CONFIG[:google_key_password]  
  #GOOGLE_ISSUER = CONFIG[:google_issuer]

  # Standard YouTube data:
  YOUTUBE_API_SERVICE_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"
  YOUTUBE_READONLY_SCOPE = 'https://www.googleapis.com/auth/youtube.readonly'

  # Editable application-specific data:
  YOUTUBE_USERS = ["dumarsengraving", "jaydumars"]
  MY_APP_NAME = "Engraver App"
  MY_APP_VER = "v1"

  attr_reader :video_results, :playlists, :all_videos

  def initialize
    start_session
    find_playlists
    find_videos_in_playlists(@playlists)
  end

  def start_session
    @client = Google::APIClient.new(key: CONFIG[:google_api_key], authorization: nil, application_name: MY_APP_NAME, application_version: MY_APP_VER)
    @youtube_api = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    key = Google::APIClient::PKCS12.load_key("#{Rails.root}/config/privatekey/#{CONFIG[:google_private_key]}", CONFIG[:google_key_password] )
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => YOUTUBE_READONLY_SCOPE,
      :issuer => CONFIG[:google_issuer],
      :signing_key => key)
    @client.authorization.fetch_access_token!
  end

  def find_playlists
    my_usernames = ["dumarsengraving", "jaydumars"]
    @playlists = my_usernames.map do |user|
      find_upload_list_for_user(user)
    end  
  end

  def find_upload_list_for_user(username)
    @result = @client.execute!(
      :api_method => @youtube_api.channels.list,
      :parameters => { part: 'contentDetails', forUsername: username} )
    @user_uploads = @result.data.items.first["contentDetails"]["relatedPlaylists"]["uploads"]
  end

  def find_videos_in_playlists(playlists)
    @video_results = {}
    playlists.map do |playlist_id|
      find_videos_in_uploads_playlist(playlist_id)
    end
  end


  def find_videos_in_uploads_playlist(playlist_id)
    @video_list_response = @client.execute!(
      :api_method => @youtube_api.playlist_items.list,
      # snake_case playlist_items due to https://code.google.com/p/google-api-ruby-client/issues/detail?id=64
      :parameters => { 
        part: "snippet", 
        playlistId: playlist_id,
        maxResults: 50 } )
    @video_list_response.data.items.each do |playlist_item|
        title = playlist_item['snippet']['title']
        video_id = playlist_item['snippet']['resourceId']['videoId']
        @video_results[video_id] = title
      end
  end



end