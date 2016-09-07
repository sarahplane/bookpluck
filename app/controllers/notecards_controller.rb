class NotecardsController < ApplicationController
  def index
    @notecards = Notecard.all
  end

  def show
    @notecard = Notecard.find(params[:id])
  end

  def new
    @notecard = Notecard.new
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
  end

private
  def notecard_params
    params.require(:notecard).permit(:title, :quote, :note)
  end
end
