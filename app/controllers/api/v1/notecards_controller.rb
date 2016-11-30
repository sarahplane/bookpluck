class Api::V1::NotecardsController < Api::V1::BaseController
  def index
    notecards = Notecard.all
    render json: notecards, status: 200   # this format can be important!
  end

  def show
    notecard = Notecard.find(params[:id])
    render json: notecard, status: 200
  end

  def create
    @notecard = Notecard.new(notecard_params)
    if @notecard.save
      render json: {
        status: 201,
        message: "Successfully created notecard",
      }.to_json
    else
      render json: { error: "#{@notecard.errors.messages.map{ |key, value| key.to_s + ' ' + value.join(" and ") }.join(", ")}", status: 400}.to_json
    end
  end

  def destroy
    notecard = Notecard.find(params[:id])
    if notecard.delete
      render json: {
        status: 200,
        message: "Successfully deleted notecard",
      }.to_json
    else
      render json: {
        status: 400,
        message: "Something went wrong",
      }.to_json
    end
  end

private

  def notecard_params
    params.require(:notecard).permit(:title, :quote, :note)
  end
end
