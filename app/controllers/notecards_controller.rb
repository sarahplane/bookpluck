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

  def download
    @notecard = Notecard.find(params[:notecard_id])
    filetitle = @notecard.title.downcase.tr(" ", "_")
    # add max characters for notecard title
    case params[:type]
    when "txt"
      data = "TITLE:\r======\r#{@notecard.title}\r\r"
      data << "QUOTE:\r======\r#{@notecard.quote}\r"
      data << "BOOK:\r=====\r#{@notecard.book.title}\r\r"
      data << "NOTE:\r=====\r#{@notecard.note}"
      send_data( data, :filename => "#{filetitle}.txt" )
    when "html"
      data = "<strong>TITLE:</strong>\r<p>#{@notecard.title}</p>\r\r"
      data << "<strong>QUOTE:</strong>\r<p>#{@notecard.quote}</p>\r"
      data << "<strong>BOOK:</strong>\r<p>#{@notecard.book.title}</p>\r\r"
      data << "<strong>NOTE:</strong>\r<p>#{@notecard.note}</p>"
      send_data( data, :filename => "#{filetitle}.html" )
    end
  end

private

  def notecard_params
    params.require(:notecard).permit(:title, :quote, :note, :theme_list,
                                     :author_names, book_attributes: [:title, :timestamp])
  end

  def set_user
    @user = current_user
  end

  def set_notecard
    @notecard = Notecard.find(params[:id])
  end

  def assign_author
    @author = Author.find_or_create_by(first_name: params[:author_first_name], last_name: params[:author_last_name])
    author_array = []
    author_array << @author
    @notecard.authors = author_array
  end
end
