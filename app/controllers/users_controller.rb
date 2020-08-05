class UsersController < ApplicationController
before_action :authenticate_user!
before_action :correct_user, only: [:edit, :update]

  	def index
  		@users = User.all
  		@user = current_user#合ってるか分からない
      @book = Book.new#合ってるか分からない
  	end

    def show
  		@user = User.find(params[:id])
      @books = @user.books.all
      @book = Book.new
    end

  	def edit
      @user_new = User.new
      @user = User.find(params[:id])
    end

  	def update
  		@user = User.find(params[:id])
  		if @user.update(user_params)
 	       redirect_to user_path(@user.id)
         flash[:notice] = "You have updated user successfully."
      else
         @user_new = User.new
         render :edit
      end
    end

  	private
  	def user_params
    	params.require(:user).permit(:name, :introduction, :profile_image)
  	end

    def correct_user
      user = User.find(params[:id])
      if user.id != current_user.id
        redirect_to user_path(current_user.id)
      end
    end


end