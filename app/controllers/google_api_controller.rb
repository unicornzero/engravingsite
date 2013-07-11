class GoogleApiController < ApplicationController
  
  require 'google/api_client'

  # Config hash values defined in config/application.yml:
  GOOGLE_DEV_KEY = CONFIG[:google_api_key]
  GOOGLE_SECRET_KEY_PATH = "#{Rails.root}/config/privatekey/#{CONFIG[:google_secret_key_path]}"
  GOOGLE_SECRET_PHRASE = CONFIG[:google_secret_phrase]  
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
    find_user_channels
  end


  def start_session
    @client = Google::APIClient.new(key: GOOGLE_DEV_KEY, authorization: nil, application_name: MY_APP_NAME, application_version: MY_APP_VER)
    @youtube_api = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    key = Google::APIClient::PKCS12.load_key(GOOGLE_SECRET_KEY_PATH, GOOGLE_SECRET_PHRASE)
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => YOUTUBE_READONLY_SCOPE,
      :issuer => GOOGLE_ISSUER,
      :signing_key => key)
    @client.authorization.fetch_access_token!
  end

  def find_user_channels
    @result = @client.execute!(
      :api_method => @youtube_api.channels.list,
      :parameters => { forUsername: "jaydumars", part: 'contentDetails'}
    )

  end

end
