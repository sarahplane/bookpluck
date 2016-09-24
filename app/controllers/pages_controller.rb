class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home], raise: false

  def home
    if current_user
      redirect_to notecards_path
    end
  end
end
