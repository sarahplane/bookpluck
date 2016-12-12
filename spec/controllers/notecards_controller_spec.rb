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
    it "responds successfully when signed in" do
      get :index

      expect(response).to be_success
    end

    context "not signed in" do

      it "will redirect to the sign in page" do
        sign_out user
        get :index

        expect(response).to redirect_to(:user_session)
      end
    end
  end

  describe "GET #new" do
    it "assigns notecard.book" do
      get :new

      expect(notecard.book).to eq(book)
    end

    context "not signed in" do

      it "will redirect to the sign in page" do
        sign_out user
        get :index

        expect(response).to have_http_status(:found)
      end
    end
  end

  context "POST #create" do
    subject(:create_notecard)  { post :create, notecard: {title: 'one', quote: 'one', note: 'one'}.merge(book_attributes), author_names: "Ray Bradbury" }

    before :each do
      create_notecard
    end

    it "responds with a redirect" do
      expect(response).to have_http_status(:found)
    end

    it "adds one notecard" do
      expect(Notecard.count).to eq 1
    end

    it "assigns the author" do
      expect(Notecard.last.authors[0].first_name).to eq("Ray")
    end

    context "failure" do
      subject(:create_failure) { post :create, notecard: {title: nil, quote: 'one', note: 'one'} }

      it "renders new on failure" do
        expect(create_failure).to render_template(:new)
      end
    end

    context "javascript format" do

      it "adds one notecard" do
        expect{ post :create, notecard: { title: 'test', quote: 'two', note: 'two' }.merge(book_attributes), format: 'js' }.to change{ Notecard.count }.by(+1)
      end
    end
  end

  describe "PUT #update" do

    it "updates the title" do
      put :update, :id => notecard.id, notecard: {title: 'two'}
      notecard.reload

      expect(notecard.title).to eq('two')
    end

    it "renders :edit on failure" do
      update_failure = put :update, :id => notecard.id, notecard: {title: ''}

      expect(update_failure).to render_template(:edit)
    end
  end

  describe "DELETE #destroy" do
    it "will be successful" do
      delete :destroy, id: notecard.id, format: 'js'

      expect(response).to have_http_status(:ok)
    end

    it "removes the notecard" do
      notecard

      expect{ delete :destroy, id: notecard.id, format: 'js' }.to change{ Notecard.count }.by(-1)
    end
  end
end
