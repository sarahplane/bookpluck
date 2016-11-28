class NotecardsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create, :edit, :update, :upload]
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
    @index = params[:index]

    respond_to do |format|
      format.html do
        if @notecard.save
          flash[:notice] = "Notecard added"
          redirect_to notecards_path
          @user.notecards << @notecard
        else
          render :new
        end
      end
      format.js do
        if @notecard.save
          @user.notecards << @notecard
        else
          render action: 'failure'
        end
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

    respond_to do |format|
      format.html
      format.js
    end
  end

  def download
    @notecard = Notecard.find(params[:notecard_id])
    file_title = @notecard.title.downcase.tr(" ", "_")

    respond_to do |format|
      format.html do
        send_data(render_to_string :template => "notecards/download", filename: "#{file_title}.html", type: 'application/html', disposition: 'attachment', layout: false)
      end
      format.text do
        response.headers['Content-Type'] = 'text/plain'
        response.headers['Content-Disposition'] = "attachment; filename=#{file_title}.txt"
        render :template => "notecards/download"
      end
    end
  end

  def upload
    if params[:my_clippings].present?
      candidates = MyClippingsToCandidates.new.kindle_parser(params[:my_clippings].read, @user.id)
      render "notecards/upload_approval", :locals => {:candidates => candidates}
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
    author_array = []
    authors = params[:author_names].split(',')
    authors.each do |author|
      # last_name, first_name = author.reverse.split(' ', 2).map{ |name| name.reverse }
      first_name, last_name = author.rpartition(" ").collect(&:strip).reject!(&:empty?)
      new_author = Author.find_or_create_by(first_name: first_name, last_name: last_name)
      author_array << new_author
    end
    @notecard.authors = author_array
  end
end
