class ThemesController < ApplicationController

  def index
    @themes = Theme.all
  end

  def show
    @user = current_user
    @theme = Theme.find(params[:id])
  end
end
