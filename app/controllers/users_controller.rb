class UsersController < ApplicationController
  before_action :signed_in_user,        only: [:edit, :update, :index, :destroy, :show, :match]
  before_action :correct_user,          only: [:edit, :update, :match]
  before_action :admin_user,            only: :destroy
  before_action :not_needed_for_signed, only: [:new, :create]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @devices = @user.devices
    @movies = get_movies(@user)
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    user_to_delete = User.find(params[:id])
    if user_to_delete == current_user
      flash[:notice] = "You can't delete yourself... dummy"
    else
      user_to_delete.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_url
  end

  def match
    updated = match_all
    redirect_to @user, :notice => "Added #{updated} associations"
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def not_needed_for_signed
      redirect_to(root_url) if signed_in?
    end
end
