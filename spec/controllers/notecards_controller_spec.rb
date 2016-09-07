require 'rails_helper'

RSpec.describe NotecardsController, type: :controller do
  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "redirects to index page" do
      post :create, notecard: {title: 'one', quote: 'one', note: 'one'}
      id = assigns(:notecard)
      expect(response).to redirect_to notecards_path
    end
  end

  describe "PATCH #update" do
    it "updates the title" do
      @notecard = Notecard.create(title: 'one', quote: 'one', note: 'one')
      patch :update, id: @notecard, notecard: {title: 'two'}
      @notecard.reload.title.should == 'two'
    end
  end

  describe "DELETE #destory" do
    it "redirects to the index page" do
      @notecard = Notecard.create(title: 'one', quote: 'one', note: 'one')
      delete :destroy, id: @notecard
      expect(response).to redirect_to notecards_path
    end
  end
end
