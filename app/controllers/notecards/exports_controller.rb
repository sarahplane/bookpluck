class Notecards::ExportsController < ApplicationController

  def index
  end

  def create
    @notecards = Notecard.all

    respond_to do |format|
      format.enex do
        response.headers['Content-Type'] = 'text/plain'
        response.headers['Content-Disposition'] = "attachment; filename=notecards.enex"
        render :template => "notecards/exports/export"
      end
    end
  end
end
