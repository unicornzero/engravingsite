## engravingsite Project

## Project Summary
This project encompasses my early efforts to dynamically load content from both the Flickr and Google APIs. It is an early version of a profile site to showcase work an artist has featured on multiple external sites.

### Project Highlights
* Flickr- Dynamically loads images currently available in a given user's Flickr photo stream. Uses the flickraw gem to connect to the Flickr API
* Google- Dynamically loads videos the user uploaded to YouTube. Connects directly to the Google API using the google-api-client gem.


### Setup info:

* cp config/application.example.yml config/application.yml
* Use 'rake secret' to generate a new :secret_token and copy it.
* Update :secret_token in config/application.yml
* Setup Flickr Integration:
    * Go to http://www.flickr.com/services/api/keys/
    * Generate Flickr API Key & Secret
    * Open config/application.yml to update :flickraw_api and :flickraw_secret
* Setup Google-API Integration:
    * Login to Google in your web browser
    * Go to Google Apis (https://code.google.com/apis/console/) 
    * Setup a project:
        * If you haven't used Google APIs yet, click the big blue Create a Project button.
        * Else, click the drop-down box in the top left to create a new project.
    * In the left navigation pane, click "Services". Enable YouTube Data API v3.
    * Setup OAuth:
        * In the left navigation pane, click "API Access". 
        * Create a OAuth Client ID by clicking on the big blue button.
        * Enter your product name (optional: add logo and url) and click Next.
        * Select "Service account" as the Application Type. This application doesn't require users to log in.
        * Click the Create Client ID button.
        * Note the password displayed. Add it to config/application.yml as :google_key_password
        * Download the private key and move it into the config/privatekey directory. Update :google_full_key_path and :google_private_key
    * Transfer information from the API Access page to config/application.yml
        * "Email Address" to :google_issuer
        * "API Key" to "google_api_key"

### Usage Notes:
* Google API Gem documented at https://github.com/google/google-api-ruby-client
* YouTube API documented at https://developers.google.com/youtube/v3/docs/

#### Notes about scope of Google API requests:
> In new tab, go to https://developers.google.com/products/ and choose the service that you would like to use. In the left menu navigate to Configuration > Management API (v3) > Resources > Authorization (https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtAuthorization). In the table below you will find the appropriate ":scope" parameter url (e.g. https://www.googleapis.com/auth/analytics.readonly). This is how you find the appropriate scope.
> > by xpepermint (http://stackoverflow.com/questions/14106337/google-api-client-rails/16471252)

####  Additional info/features that may be added later...
* Ruby version
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions



