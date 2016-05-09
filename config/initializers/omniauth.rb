require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "de749146372b4db08280fc58598dbb3e", "ed6f9368e00e40f8bd2a69488034fcbe", scope: 'user-top-read user-library-read' 



end