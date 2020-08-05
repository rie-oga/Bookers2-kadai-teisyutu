class BooksController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:edit, :update]

	def index
		@books = Book.all
		@book = Book.new
    @users = User.all
    @user = current_user
  end

 	def show
    @book = Book.new
 		@book_detail = Book.find(params[:id])
    @user = @book_detail.user
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id
      if @book.save
    	   redirect_to book_path(@book.id)
    	   flash[:notice] = "You have created book successfully."
    	else
    	   @books = Book.all
         @users = User.all
         @user = current_user
    	   render :index
    	end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
  		@book = Book.find(params[:id])
  		if @book.update(book_params)
  		   redirect_to book_path(@book.id)
  		   flash[:notice] = "You have created book successfully."
      else
  		   flash[:notice]
    	   render :edit
	   end
  end

	def destroy
  		@book = Book.find(params[:id])
  		@book.destroy
  		redirect_to books_path
  end

  	private
  	def book_params
    	params.require(:book).permit(:title, :body)
  	end

    def correct_user
      book = Book.find(params[:id])
      if book.user.id != current_user.id
        redirect_to books_path
      end
    end

end
