class Api::V1::NotecardsController < Api::V1::BaseController
  def index
    notecards = Notecard.all
    render json: notecards, status: 200   # this format can be important!
  end

  def show
    notecard = Notecard.find(params[:id])
    render json: notecard, status: 200
  end
end
