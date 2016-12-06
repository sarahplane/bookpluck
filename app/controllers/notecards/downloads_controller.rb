class Notecards::DownloadsController < ApplicationController

  def create
    @notecard = Notecard.find(params[:notecard_id])
    file_title = @notecard.title.downcase.tr(" ", "_")

    respond_to do |format|
      format.html do
        send_data(render_to_string template: "notecards/download",
                  filename: "#{file_title}.html",
                  type: 'application/html',
                  disposition: 'attachment',
                  layout: false)
      end
      format.text do
        response.headers['Content-Type'] = 'text/plain'
        response.headers['Content-Disposition'] = "attachment; filename=#{file_title}.txt"
        render :template => "notecards/download"
      end
    end
  end
end
