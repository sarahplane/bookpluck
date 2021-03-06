class Api::V1::NotecardsController < Api::V1::BaseController
  def index
    notecards = Notecard.all
    render json: notecards, status: :ok
  end

  def show
    notecard = Notecard.find(params[:id])
    render json: notecard, status: :ok
  end

  def create
    @notecard = Notecard.new(notecard_params)
    if params[:book_attributes].present?
      @notecard.book = Book.find_or_create_by(title: params[:book_attributes][:title])
    end
    @user = current_user
    assign_author
    if params[:theme_list].present?
      @notecard.theme_list=(params[:theme_list])
    end

    if @notecard.save
      render json: {
        status: :created,
        message: "Successfully created notecard",
      }.to_json
      @user.notecards << @notecard
    else
      render json: {
        status: :bad_request,
        message: "Notecard could not be saved",
        errors: "#{@notecard.errors.messages.map{ |key, value| key.to_s + ' ' + value.join(" and ") }.join(", ")}"
      }.to_json
    end
  end

  def update
    @notecard = Notecard.find(params[:id])
    @notecard.theme_list=(params[:theme_list]) unless params[:theme_list].nil?
    if !params[:book_attributes].nil?
      @notecard.book = Book.find_or_create_by(title: params[:book_attributes][:title])
    end
    assign_author unless params[:author_names].nil?

    if @notecard.update(notecard_params)
      render json: {
        status: :ok,
        message: "Successfully updated notecard",
      }.to_json
    else
      render json: {
        status: :bad_request,
        message: "Notecard could not be updated",
        errors: "#{@notecard.errors.messages.map{ |key, value| key.to_s + ' ' + value.join(" and ") }.join(", ")}"
      }.to_json
    end
  end

  def destroy
    notecard = Notecard.find(params[:id])
    if notecard.delete
      render json: {
        status: :ok,
        message: "Successfully deleted notecard",
      }.to_json
    else
      render json: {
        status: :bad_request,
        message: "Something went wrong",
      }.to_json
    end
  end

private

  def notecard_params
    params.require(:notecard).permit(:title, :quote, :note, :author_names, :theme_list, book_attributes: [:title, :timestamp])
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
