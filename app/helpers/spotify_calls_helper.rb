module SpotifyCallsHelper
	def user_call 
		RSpotify::User.new(session[:spotify])
	end

	def saved_tracks(k,i)
		@user.saved_tracks(limit:k,offset:i)
	end

	def related_a(id)
		artist = RSpotify::Artist.find(id)
		artist.related_artists
	end

	def favor 
		user.top_artists[0..19]
	end

	def play_lists
		@user.playlists
	end
	# playlists tracks
	def play_tracks(play) 
		play.tracks
	end

end