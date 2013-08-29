module DevicesHelper
	def setup_devices
		@devices = @user.devices.to_a
	end

	def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end