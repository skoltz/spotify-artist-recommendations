class UsersController < ApplicationController
  	def initialize
      # @artists = {artist id => artist name}
      @artists = {}
      # related artist count is a counter of rec. artists based on the 20 similar artists for each unique track in a user's library 
      @rel_art_count = Hash.new(0)
    end

    # get user's top artists, generates a hash for highcharts
    def top_artists(spot_user)
      @top_artists_hash = {}
      spot_user.top_artists[0..19].each do |fav|
        @top_artists_hash[fav.name] = {}

        @user_artist_related[fav.name].each do |fav_rel_art|
          @top_artists_hash[fav.name][fav_rel_art] = {}
          
          @rel_artist_rec[fav_rel_art].each do |user_also_rec|
            if fav.name != user_also_rec
              @top_artists_hash[fav.name][fav_rel_art][user_also_rec] = "1"
            end
          end
          if @top_artists_hash[fav.name][fav_rel_art] == {}
            @top_artists_hash[fav.name][fav_rel_art]["none"] = "0"            
          end
        end
      end
      @top = @top_artists_hash.to_json

    end
    # json opbject for highcharts
    #   @top_artists_hash =  { 
    #     "sufjan" =  {
    #        rec1 =  {
    #           "otherUserArtist1" = 1,
    #           otherUserArtist2 = 1
    #         },
    #         rec2 = {
    #           otherUserArtist3 = 1,
    #           otherUserArtist4 = 1
    #         }
    #     }
    #   }


    def spotify
      # receive user's info from spotify
    	@spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      # api limited, must use counters to offset and repeat call
  		i = 0 
  		k = 20 
  		until @spotify_user.saved_tracks(limit:k,offset:i) == [] do 
  			@spotify_user.saved_tracks(limit:k,offset:i).each do |art|
				name = art.artists[0].name
        # if artist not in artists hash
				if !@artists.values.include?(name)
					@artists[art.artists[0].id] = name
				end
			end
			i += 20
		end
		related
	end

  	def related
  		@user_artist_related = Hash.new{|h,k| h[k] = [] }   # users artists to arr of 20 recommended {"Tame Impala"=>["Grizzly Bear",Kurt Vile"]} 
  		@rel_artist_rec = Hash.new{|h,k| h[k] = [] }     # recommended artists to arr of user's artist they were recommended from 
      # iterating through user's artist ids, api for related artists
      @artists.keys.each do |art|
			  rel_art_info = JSON.load(open("https://api.spotify.com/v1/artists/#{art}/related-artists"))
  			rel_art_info["artists"].each do |rel|
          # if not an artist in user's saved track list  				
          if !@artists.keys.include?(rel["id"])     
            @user_artist_related[@artists[art]] << rel["name"]
            @rel_artist_rec[rel["name"]] << @artists[art]     # adding user's artist to hash of recommended
  					@rel_art_count[rel["name"]] += 1
  				end
  			end
  		end
      # output for view, the 30 most frequent counted similar artists
      @output = @rel_art_count.sort_by { |k,v| v }.reverse[0..30].to_h
      top_artists(@spotify_user)
  	end

end

