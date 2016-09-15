class NotecardsController < ApplicationController
  def index
    @notecards = Notecard.all
  end

  def show
    @notecard = Notecard.find(params[:id])
  end

  def new
    @notecard = Notecard.new
    @book = Book.new
    @notecard.book = @book
  end

  def create
    @notecard = Notecard.new(notecard_params)
    @notecard.title = params[:notecard][:title]

    if @notecard.save
      flash[:notice] = "Notecard added"
      redirect_to notecards_path
    else
      render :new
    end
  end

  def edit
    @notecard = Notecard.find(params[:id])
  end

  def update
    @notecard = Notecard.find(params[:id])

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
    params.require(:notecard).permit(:title, :quote, :note, book_attributes: [:title, :publisher, :editor, :isbn, :year_published, :timestamp])
  end
end
