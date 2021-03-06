class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
	    if user && user.authenticate(params[:session][:password])
	      flash[:success] = 'Succesfully logged in'
	      sign_in user
	      redirect_back_or user
	    else
	      flash.now[:error] = 'Invalid email/password combination'
	      render 'new'
	    end
	end

	def destroy
		sign_out
		flash[:success] = 'Succesfully logged out'
		session.delete(:return_to)
		redirect_to root_url
	end
end
