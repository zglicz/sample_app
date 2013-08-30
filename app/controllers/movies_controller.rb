class MoviesController < ApplicationController
	before_action :signed_in_user, :correct_user_with_user_id, :setup_devices

	def show
		@movie = Movie.find(params[:id])
	end
end