require 'rails_helper'

RSpec.describe NotecardsController, type: :controller do
  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end
end
