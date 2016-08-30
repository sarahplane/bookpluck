require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "responds successfully" do
      get :home
      expect(response).to be_success
    end
  end
end
