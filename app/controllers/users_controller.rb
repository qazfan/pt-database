class UsersController < ApplicationController
  before_action :authenticate_admin!, only: [:verification, :edit, :update]

  def index
    if params[:unamesearch].present?
      @users = User.unamesearch(params[:unamesearch]).paginate(:page => params[:page]).order("id DESC")
    else
      @users = User.paginate(:page => params[:page]).order("id DESC")
    end
  end

  # GET to /users/:id
  def show
    @user = User.find( params[:id] )
    @pets = @user.pets
    if user_signed_in? && current_user.id == @user.id
      @user.pets.each do |pet|
        if pet.verified == false
          flash.now[:warning] = "Looks like you have some unverified pets. If they have been "\
            "unverified for a while, make sure they're wearing a "\
            "<a href='https://www.neopets.com/shops/wizard.phtml?string=Mossy+Rock'>"\
            "Mossy Rock</a>".html_safe
          break
        end
      end
    end
  end

  def verification
    @users = User.includes(:pet)
    @pets = Pet.includes(:user).where(verified: false).paginate(:page => params[:page]).order("id DESC").reverse_order
  end

  def edit
    @user = User.find( params[:id] )
  end

  #PUT to /users/
  def update
    #Retrieve user from database
    @user = User.find_by_id( params[:id] )
    #Mass assign edited attributes and save (update)
    if @user.update(user_params)
      flash[:success] = "User updated!"
      #Redirect user to page
      redirect_to user_path(id: params[:id] )
    else
      flash[:danger] = @user.errors.full_messages.join(", ")
      render action: :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @pets = Pet.includes(:user).all
    @user.pets.each do |pet|
      pet.destroy
    end
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(:id, :username, :banned)
    end

end