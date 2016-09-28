class ThemesController < ApplicationController
  def show
    @user = current_user
    @theme = Theme.find(params[:id])
  end
end
