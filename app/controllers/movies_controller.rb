class MoviesController < ApplicationController
	before_action :signed_in_user, :correct_user_with_user_id, :setup_devices, :setup_movie

	def show
		if not @movie.tagged
			imdb_search_object = IMDB.new(process_folder_name(@movie.folder_name)).search
			hashyk = JSON.parse imdb_search_object.body
			@imdb_search = hashyk['Search']
		else # tagged movie
			imdb_search_object = IMDB.new(@movie.imdb_id).info
			@imdb_search = JSON.parse imdb_search_object.body
		end
	end

	def update
		imdb_info = params[:movie][:imdb_id]
		if imdb_info
			result = imdb_info.split('_')
			@movie.imdb_id = result[0]
			@movie.tagged = true
			@movie.name = result[1]
			@movie.save
			flash[:success] = "Successfully tagged movie"
		else
			flash[:error] = "Select one movie"
		end
		redirect_to [@user, @movie]
	end

	def destroy
		if @movie.tagged
			@movie.name = @movie.folder_name
			@movie.tagged = false
			@movie.imdb_id = nil
			@movie.save
			flash[:success] = "Removed association"
		end
		redirect_to [@user, @movie]
	end

private
	
	def setup_movie
		@movie = Movie.find(params[:id])
	end
end