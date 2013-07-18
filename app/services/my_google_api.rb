class MyGoogleAPI
  
  require 'google/api_client'
  attr_reader :video_results


  def initialize
    start_session
    find_playlists
    find_videos_in_playlists(@playlists)
  end

  def find_playlists
    my_usernames = @youtube_users
    @playlists = my_usernames.map do |user|
      find_upload_list_for_user(user)
    end  
  end

  def find_videos_in_playlists(playlists)
    @video_results = {}
    playlists.map do |playlist_id|
      find_videos_in_uploads_playlist(playlist_id)
    end
  end


  private
      def start_session
        set_instance_variables
        
        @client = Google::APIClient.new(key: CONFIG[:google_api_key], authorization: nil, application_name: @my_app_name, application_version: @my_app_ver)
        @youtube_api = @client.discovered_api(@youtube_api_service_name, @youtube_api_version)
        key = Google::APIClient::PKCS12.load_key("#{Rails.root}/config/privatekey/#{CONFIG[:google_private_key]}", CONFIG[:google_key_password] )
        @client.authorization = Signet::OAuth2::Client.new(
          :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          :audience => 'https://accounts.google.com/o/oauth2/token',
          :scope => @youtube_readonly_scope,
          :issuer => CONFIG[:google_issuer],
          :signing_key => key)
        @client.authorization.fetch_access_token!
      end

      def set_instance_variables
        # Standard YouTube data:
        @youtube_api_service_name = "youtube"
        @youtube_api_version = "v3"
        @youtube_readonly_scope = 'https://www.googleapis.com/auth/youtube.readonly'

        # Editable application-specific data:
        @youtube_users = ["dumarsengraving", "jaydumars"]
        @my_app_name = "Engraver App"
        @my_app_ver = "v1"
      end

      def find_upload_list_for_user(username)
        @result = @client.execute!(
          :api_method => @youtube_api.channels.list,
          :parameters => { part: 'contentDetails', forUsername: username} )
        @user_uploads = @result.data.items.first["contentDetails"]["relatedPlaylists"]["uploads"]
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