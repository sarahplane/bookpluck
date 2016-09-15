require 'rails_helper'

RSpec.describe NotecardsController, type: :controller do
  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "responds with a 200 status" do
      post :create, notecard: {title: 'one', quote: 'one', note: 'one'}
      id = assigns(:notecard)
      expect(response.status).to eq(200)
    end
  end

  describe "PATCH #update" do
    it "updates the title" do
      @book = Book.create(title: 'one')
      @notecard = Notecard.create(title: 'one', quote: 'one', note: 'one', book: @book)
      patch :update, :id => @notecard.id, notecard: {title: 'two'}
      @notecard.reload.title.should == 'two'
    end
  end

  describe "DELETE #destory" do
    it "redirects to the index page" do
      book = Book.create(title: 'one')
      notecard = Notecard.create(title: 'one', quote: 'one', note: 'one', book: book)
      delete :destroy, id: notecard.id
      expect(response).to redirect_to notecards_path
    end
  end
end
