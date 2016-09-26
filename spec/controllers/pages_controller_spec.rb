require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "responds successfully" do
      get :home
      expect(response).to be_success
    end

    it "redirects current user" do
      @user = User.create(email: "user@user.com", password: "123456", password_confirmation: "123456")
      @user.confirm
      @user.save
      sign_in @user
      get :home
      expect(response).to redirect_to(notecards_path)
    end
  end
end
