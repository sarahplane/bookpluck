require 'rails_helper'

RSpec.describe Api::V1::NotecardsController, type: :controller do
  let (:user) { User.create(email: "user@user.com",
                            password: "123456",
                            password_confirmation: "123456",
                            confirmed_at: Time.now) }
  let (:book) { Book.create(title: 'Book')}
  let (:book_attributes) { {book_attributes: {title: "a title"}} }
  let (:notecard) { Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book )}

  context "unauthenticated user" do
    it "can't get index" do
      get :index

      expect(response).to have_http_status(401)
    end
  end

  context "authorized user" do
    before :each do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.api_auth_token)
    end

    describe "GET #index" do

      it "succeeds" do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it "responds with JSON" do
        get :index

        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct data" do
        notecard
        get :index

        expect(response.body).to eq [notecard].to_json
      end
    end

    describe "GET #show" do
      it "succeeds" do
        get :show, id: notecard

        expect(response).to have_http_status(:ok)
      end

      it "responds with JSON" do
        get :show, id: notecard

        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct data" do
        get :show, id: notecard

        expect(response.body).to eq notecard.to_json
      end

      it "rescues from record not found error" do
        get :show, id: 1234

        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(404)
      end
    end

    describe "POST #create" do
      it "creates a notecard" do
        expect{ post :create, {"notecard": {"title": "test", "quote": "test"}}, format: JSON }.to change{ Notecard.count }.by(1)
      end

      it "accepts book_attributes and theme_list params" do
        post :create, {"notecard": {"title": "Notecard 2", "quote": "test2"}, "author_names": "New Author", "theme_list": "A, B, C", "book_attributes": {"title": "C"}}, format: JSON

        expect(Notecard.last.authors[0].first_name).to eq("New")
      end

      it "fails without params" do
        expect{ post :create, {"notecard": {}}, format: JSON }.to raise_error
      end

      it "returns an error message on failure" do
        post :create, {"notecard": {"title": "#{"N"*51}", "quote": "test"}}, format: JSON
        # triggers the notecard validation that limits titles to 50 characters

        expect(response.body).to include  "Notecard could not be saved"
      end
    end

    describe "PUT #update" do
      it "updates a notecard" do
        put :update, {"notecard": {"title": "New Title", "quote": "test"}, "book_attributes": {"title": "C"}, "id": "#{notecard.id}"}, format: JSON
        notecard.reload

        expect(notecard.title).to eq("New Title")
      end

      it "returns an error message on failure" do
        put :update, {"notecard": {"title": "#{"N"*51}", "quote": "test"}, "book_attributes": {"title": "C"}, "id": "#{notecard.id}"}, format: JSON
        # triggers the notecard validation that limits titles to 50 characters

        expect(response.body).to include "Notecard could not be updated"
      end
    end

    describe "DELETE #destroy" do
      it "is successful" do
        delete :destroy, id: notecard.id, format: JSON

        expect(response.status).to eq 200
      end
    end
  end
end
