class MoviesController < ApplicationController
	before_action :signed_in_user, :correct_user_with_user_id, :setup_devices, :setup_movie

	def show
		@imdb_search = @movie.tagged ? search_by_id(@movie.imdb_id) : search_by_name(@movie.folder_name)
	end

	def update
		imdb_info = params[:movie][:imdb_id]
		if imdb_info
			update_data(@movie, imdb_info)
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