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
    if @theme.destroy
      flash[:notice] = "theme deleted"
    else
      flash.now[:alert] = "theme NOT deleted, please try again"
    end
    redirect_to themes_path
  end
end
