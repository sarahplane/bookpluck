class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception, prepend: true
  after_action :store_action

  def store_action
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      store_location_for(:user, notecards_path)
      # redirects to notecard index after sign-in
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
    super resource
  end
end
