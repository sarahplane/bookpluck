class ThemesController < ApplicationController

  def index
    @themes = Theme.all
  end

  def show
    @user = current_user
    @theme = Theme.find(params[:id])
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.delete

    respond_to do |format|
      format.html
      format.js
    end
  end
end
