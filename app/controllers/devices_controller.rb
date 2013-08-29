class DevicesController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user
	before_action :setup_devices, only: [:index, :show, :create]
	before_action :setup_current_device, only: [:show, :update]

	def index
		@device = @user.devices.build
	end

	def show
		@movies = @device.movies.paginate(page: params[:page])
	end

	def create
		@device  = @user.devices.build(device_params)
		if @device.save
			flash[:success] = "Device saved" 
			redirect_to user_devices_path(@user)
		else
			render 'index'
		end
	end

	def destroy
		@user.devices.find(params[:id]).destroy
		flash[:success] = "Successfully deleted device"
		redirect_to user_devices_path(@user)
	end

	def update
		if @device.update_attributes(device_params)
			flash[:success] = "Successfully updated device info"
		else
			@device = @user.devices.find(params[:id])
			flash[:error] = "Unable to update device: error"
		end
		redirect_to url_for([@user, @device])
	end

	private

		def setup_current_device
			@device = @user.devices.find(params[:id])
		end

		def device_params
			params.require(:device).permit(:name, :description)
		end

		def signed_in_user
	      store_location
      	  redirect_to signin_url, notice: "Please sign in." unless signed_in?
	    end

	    def correct_user
	    	@user = User.find(params[:user_id])
      		redirect_to(root_url) unless current_user?(@user)
	    end
end