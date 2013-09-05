class MoviesController < ApplicationController
	before_action :signed_in_user, :correct_user_with_user_id, :setup_devices	

	def show
		@movie = Movie.find(params[:id])
		if not @movie.tagged
			imdb_search_object = IMDB.new(process_folder_name(@movie.folder_name)).search
			hashyk = JSON.parse imdb_search_object.body
			@imdb_search = hashyk['Search']
		end
	end
end