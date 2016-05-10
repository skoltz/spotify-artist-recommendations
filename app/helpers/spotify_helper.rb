module SpotifyHelper
	def current_user
		if session[:spotify]
			@current_user ||= RSpotify::User.new(session[:spotify])
		end
	end

end