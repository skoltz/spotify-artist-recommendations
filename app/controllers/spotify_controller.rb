class SpotifyController < ApplicationController
    include RelatedHelper
    include SpotifyHelper

    def home 
    end

    def show
      # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      session[:spotify] = request.env['omniauth.auth']
      users_artists
      related_art

      # session[:output], session[:artists_all_info], session[:rel_artist_rec], session[:user_artist_related] = @output, @artists_all_info, @rel_artist_rec, @user_artist_related

      render :action => 'compare'

    end

    def compare
    end

    def logout
      session.delete(:spotify)
      redirect_to root_path
    end
end

