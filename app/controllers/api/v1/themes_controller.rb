class Api::V1::ThemesController < Api::V1::BaseController
  def index
    themes = Theme.all
    render json: themes, status: :ok
  end

  def show
    theme = Theme.find(params[:id])
    render json: theme, status: :ok
  end
end
