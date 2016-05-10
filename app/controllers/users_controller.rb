class UsersController < ApplicationController

    def spotify
      # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      session[:spotify] = request.env['omniauth.auth']
      redirect_to root_path
    end

    def logout
      binding.pry
      session.delete(:spotify)
      redirect_to root_path
    end

end

