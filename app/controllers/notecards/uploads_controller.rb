class Notecards::UploadsController < ApplicationController

  def index
  end

  def new
  end

  def create
    if params[:my_clippings].present?
      candidates = MyClippingsToCandidates.new.kindle_parser(params[:my_clippings].read, current_user.id)
      render "notecards/uploads/index", locals: { candidates: candidates }
    else
      flash[:alert] = "Must choose a file"
      redirect_to new_notecards_upload_path
    end
  end
end
