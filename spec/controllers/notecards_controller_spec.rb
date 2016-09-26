require 'rails_helper'

RSpec.describe NotecardsController, type: :controller do

  include Devise::Test::ControllerHelpers

  before(:each) do
    @user = User.create(email: "user@user.com", password: "123456", password_confirmation: "123456")
    @user.confirm
    @user.save
    sign_in @user
  end

  before(:each) do
    @book = Book.create(title: 'Book')
    @notecard = Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: @book)
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "assigns @notecard.book" do
      get :new
      expect(@notecard.book).to eq(@book)
    end
  end

  describe "POST #create" do
    it "responds with a 200 status" do
      post :create, notecard: {title: 'one', quote: 'one', note: 'one'}
      expect(response.status).to eq(200)
    end

    it "redirects notecards index" do
      post :create, notecard: {title: 'two', quote: 'one', note: 'one', book: @book}
      expect(response).to redirect_to(notecards_path)
    end
  end

  describe "PATCH #update" do
    it "updates the title" do
      patch :update, :id => @notecard.id, notecard: {title: 'two'}
      @notecard.reload
      expect(@notecard.title).to eq('two')
    end
  end

  describe "DELETE #destory" do
    it "redirects to the index page" do
      delete :destroy, id: @notecard.id
      expect(response).to redirect_to notecards_path
    end
  end
end
