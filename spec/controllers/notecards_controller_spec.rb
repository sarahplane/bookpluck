require 'rails_helper'

RSpec.describe NotecardsController, type: :controller do

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}
  let (:book) { Book.create(title: 'Book')}
  let (:book_attributes) { {book_attributes: {title: "a title"}} }
  let (:notecard) { Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book )}
  let (:author) { Author.create(first_name: "First", last_name: "Last") }
  let (:theme_a) { Theme.create(name: 'alpha') }
  let (:theme_z) { Theme.create(name: 'zed') }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index

      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "assigns notecard.book" do
      get :new

      expect(notecard.book).to eq(book)
    end
  end

  context "POST #create" do
    subject(:create_notecard)  { post :create, notecard: {title: 'one', quote: 'one', note: 'one'}.merge(book_attributes) }

    before :each do
      create_notecard
    end

    it "responds with a redirect" do

      expect(response.status).to eq(302)
    end

    it "adds one article" do

      expect(Notecard.count).to eq 1
    end
  end

  describe "PUT #update" do
    it "updates the title" do
      put :update, :id => notecard.id, notecard: {title: 'two'}
      notecard.reload

      expect(notecard.title).to eq('two')
    end
  end

  describe "DELETE #destroy" do
    it "will be successful" do
      delete :destroy, id: notecard.id, format: 'js'

      expect(response.status).to eq 200
    end

    it "removes the notecard" do
      notecard

      expect{delete :destroy, id: notecard.id, format: 'js'}.to change{Notecard.count}.by(-1)
    end
  end

  describe "GET #download" do
    it "is successful with file type: txt" do
      notecard.authors << author
      get :download, notecard_id: notecard.id, file_type: "txt"

      expect(response.status).to eq 200
    end

    it "is successful with file type: html" do
      notecard.authors << author
      get :download, notecard_id: notecard.id, file_type: "html"

      expect(response.status).to eq 200
    end
  end

  describe "GET #upload" do

    it "will redirect with an error without the my_clippings param" do
      get :upload

      expect(response.status).to eq 302
    end

    it "will redirect to uploader upon failure" do
      get :upload

      expect(response).to redirect_to(uploader_notecards_path)
    end
  end

  describe "GET #report" do
    it "will be successful" do
      get :report

      expect(response.status).to eq 200
    end
  end
end
