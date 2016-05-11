# class HomeController < ApplicationController
# 	include SpotifyHelper

# 	def index
# 	end

# 	def home

# 	end

# 	#not in use
# 	def show
# 		user_search = params["artist"]["artist"].downcase.gsub(" ","+")
# 		@artist_search = JSON.load(open("https://api.spotify.com/v1/search?q=#{user_search}&type=artist"))
# 		@artist_id = @artist_search["artists"]["items"][0]["id"]
# 		@artist_info = JSON.load(open("https://api.spotify.com/v1/artists/#{@artist_id}/related-artists"))
# 		@name = []

# 		@artist_info["artists"].each do |y|
			
# 			@name << y["name"]
# 		end

# 	end


# end
