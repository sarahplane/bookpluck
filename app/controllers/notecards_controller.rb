class NotecardsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create, :edit, :update]
  before_action :set_notecard, only: [:show, :edit, :update, :destroy]

  def index
    @notecards = Notecard.includes(:book, :quotations, :authors, :themings, :themes)
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
    assign_author
    @index = params[:index]

    respond_to do |format|
      if @notecard.save
        format.html do
          flash[:notice] = "Notecard added"
          redirect_to notecards_path
          @user.notecards << @notecard
        end
        format.js { @user.notecards << @notecard }
      else
        format.html { render :new }
        format.js { render(action: 'failure') }
      end
    end
  end

  def edit
  end

  def update
    assign_author

    if @notecard.update(notecard_params)
      respond_to do |format|
        format.html do
          flash[:notice] = "Notecard #{'"'}#{@notecard.title}#{'"'} Edited"
          redirect_to notecards_path
        end
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    @notecard.delete
  end

  def report
    @books = Book.has_notecards_by_count
    @themes = Theme.alphabetized
  end

private

  def notecard_params
    params.require(:notecard).permit(:id, :title, :quote, :note, :theme_list, :author_names,
                                     book_attributes: [:title, :timestamp])
  end

  def set_user
    @user = current_user
  end

  def set_notecard
    @notecard = Notecard.includes(:book, :quotations, :authors).find(params[:id])
  end

  def assign_author
    unless params[:author_names] == nil
      author_array = []
      authors = params[:author_names].split(',')
      authors.each do |author|
        first_name, last_name = author.rpartition(" ").collect(&:strip).reject!(&:empty?)
        new_author = Author.find_or_create_by(first_name: first_name, last_name: last_name)
        author_array << new_author
      end
      @notecard.authors = author_array
    end
  end
end
