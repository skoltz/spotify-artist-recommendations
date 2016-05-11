class UsersController < ApplicationController
    include RelatedHelper

    def spotify
      # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      session[:spotify] = request.env['omniauth.auth']
      users_artists
      related_art


      <%= render partial: "related_artists" %>
   
    end

    def logout
      session.delete(:spotify)
      redirect_to root_path
    end

end

