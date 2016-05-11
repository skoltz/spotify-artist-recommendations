module RelatedHelper
  	include SpotifyCallsHelper

    def users_artists
      # receive user's info from spotify
      @user = user_call
      @artists_all_info = {} #{name =[id, uri]}   // all artists
      @artists = {}
      # @artists = {artist id => artist name}  // artists from user's saved tracks
  		i = 0 
  		k = 40 
      # api limited, use counters to offset and repeat call
      u_saved = saved_tracks(k,i)
  		until u_saved == [] do 
  			u_saved.each do |art|
				  name = art.artists[0].name
          # add to all_artists_info hash
          @artists_all_info[name] = [art.artists[0].id, art.artists[0].uri]
          # if artist not in artists hash
					@artists[art.artists[0].id] ||= name
        end
        i += 40 
        u_saved = saved_tracks(k,i)
      end
	   end


  	def related_art
  		@user_artist_related = Hash.new{|h,k| h[k] = [] }   # users artists to arr of 20 recommended {"Tame Impala"=>["Grizzly Bear",Kurt Vile"]} 
  		@rel_artist_rec = Hash.new{|h,k| h[k] = [] }     # recommended artists to arr of user's artist they were recommended from 
      @rel_art_count = Hash.new(0)

      # iterating through user's artist ids, api for related artists
      @artists.keys.each do |a_id|
        @rel_art_info = related_a(a_id)  # call to spot_calls_helper for array of 20 artists
        @rel_art_info.each do |related|
          # if not an artist in user's saved track list  				
          builder(related, a_id)
        end
      end
      # output for view, most frequent counted similar artists
      @output = @rel_art_count.sort_by { |k,v| v }.reverse[0..29]
    end

    def builder(related, id_art)
      if !@artists.keys.include?(related.id)
        # add to all_artists_info hash
        @artists_all_info[related.name] ||= [related.id, related.uri] 
        @user_artist_related[@artists[id_art]] << related.name
        @rel_artist_rec[related.name] << @artists[id_art]     # adding user's artist to hash of recommended
        @rel_art_count[related.name] += 1          
      end
    end      

    # playlists

    # def user_playlists
    #   @u_playlists = {}
    #   @all_songs_count = @rel_art_count

    #   p_lists = play_lists
    #   p_lists.each do |play|
    #     p_list_tracks = play_tracks(play)
    #     p_list_tracks.each do |song|

    #     end
    #   end
    # end

    # def play_builder(song)
    #   @u_playlists[song.artists[0].id] ||= song.artists[0].name
    # end



    # get user's top artists, generates a hash for highcharts
    def top_artists
      @top_artists_hash = {}
      fav_artists = favor
      fav_artists.each do |f|
        @top_artists_hash[f.name] = {}
        @user_artist_related.each do |f_rel_art|
          @top_artists_hash[f.name][f_rel_art] = {}
          @rel_artist_rec[f_rel_art].each do |user_also_rec|
            if f.name != user_also_rec
              @top_artists_hash[f.name][f_rel_art][user_also_rec] = "1"
            end
          end
          if @top_artists_hash[f.name][f_rel_art] == {}
            @top_artists_hash[f.name][f_rel_art]["none"] = "0"
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


end

