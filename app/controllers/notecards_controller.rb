class NotecardsController < ApplicationController

  def index
    @user = current_user
    @notecards = Notecard.all
  end

  def show
    @notecard = Notecard.find(params[:id])
  end

  def new
    @user = current_user
    @notecard = Notecard.new
    @book = Book.new
    @notecard.book = @book
  end

  def create
    @user = current_user
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
    @user = current_user
    @notecard = Notecard.find(params[:id])
  end

  def update
    @user = current_user
    @notecard = Notecard.find(params[:id])
    assign_author

    if @notecard.update(notecard_params)
      flash[:notice] = "notecard #{@notecard.title} edited"
      redirect_to notecards_path
    else
      render :edit
    end
  end

  def destroy
    @notecard = Notecard.find(params[:id])
    old_title = @notecard.title
    if @notecard.destroy
      flash[:notice] = "notecard #{old_title} deleted"
    else
      flash.now[:alert] = "notecard #{@notecard.title} NOT deleted, please try again"
    end
    redirect_to notecards_path
  end

private
  def notecard_params
    Rails.logger.info "test"
    params.require(:notecard).permit(:title, :quote, :note,
                                     :author_names, book_attributes: [:title, :publisher, :editor, :isbn, :year_published, :timestamp])
  end

  def assign_author
    if params[:author_first_name] == ""
      @notecard.errors.add(:author_first_name, "must be present")
    else
      @author = Author.find_or_create_by(first_name: params[:author_first_name], last_name: params[:author_last_name])
      @notecard.authors << @author
    end
  end
end
