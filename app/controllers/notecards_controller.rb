class NotecardsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create, :edit, :update, :upload]
  before_action :set_notecard, only: [:show, :edit, :update, :destroy, :upload_approval]

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

    respond_to do |format|
      format.html
      format.js
    end
  end

  def download
    @notecard = Notecard.find(params[:notecard_id])
    file_title = @notecard.title.downcase.tr(" ", "_")
    file_type = params[:file_type]
    send_data( @notecard.build_download_data(file_type), :filename => "#{file_title}.#{file_type.to_s}" )
  end

  def upload
    if params[:my_clippings].present?
      ids = MyClippingsToNotecards.parser(params[:my_clippings].read, @user.id)
      ids.reject!{|a| a.blank?}
      render :template => "notecards/upload_approval", :locals => {:ids => ids}
    else
      flash[:alert] = "Must choose a file"
      redirect_to uploader_notecards_path
    end
  end

  def uploader
  end

  def upload_approval
  end

  def report
    @books = Book.has_notecards_by_count
    @themes = Theme.alphabetized
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
