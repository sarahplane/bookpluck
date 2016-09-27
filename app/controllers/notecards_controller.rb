class NotecardsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create, :edit, :update]
  before_action :set_notecard, only: [:show, :edit, :update, :destroy]

  def index
    @notecards = Notecard.all
  end

  def show
  end

  def new
    @notecard = Notecard.new
    @book = Book.new
    @notecard.book = @book
  end

  def create
    @notecard = Notecard.new(notecard_params)
    @notecard.title = params[:notecard][:title]
    assign_author

    if @notecard.save
      flash[:notice] = "Notecard added"
      redirect_to notecards_path
      @user.notecards << @notecard
    else
      render :new
    end
  end

  def edit
  end

  def update
    assign_author

    if @notecard.update(notecard_params)
      flash[:notice] = "Notecard #{'"'}#{@notecard.title}#{'"'} Edited"
      redirect_to notecards_path
    else
      render :edit
    end
  end

  def destroy
    old_title = @notecard.title
    if @notecard.destroy
      flash[:notice] = "notecard #{old_title} deleted"
    else
      flash.now[:alert] = "notecard #{'"'}#{@notecard.title}#{'"'} NOT deleted, please try again"
    end
    redirect_to notecards_path
  end

private
  def notecard_params
    params.require(:notecard).permit(:title, :quote, :note, :theme_list,
                                     :author_names, book_attributes: [:title, :timestamp])
  end

  def assign_author
    @author = Author.find_or_create_by(first_name: params[:author_first_name], last_name: params[:author_last_name])
    author_array = []
    author_array << @author
    @notecard.authors = author_array
  end

  def set_user
    @user = current_user
  end

  def set_notecard
    @notecard = Notecard.find(params[:id])
  end
end
