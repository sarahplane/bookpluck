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

    describe "GET index" do

      it "succeeds" do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it "responds with JSON" do
        get :index

        expect(response.content_type).to eq 'application/json'
      end

      it "succeeds" do
        notecard
        get :index

        expect(response.body).to eq [notecard].to_json
      end
    end

    describe "GET show" do
      it "succeeds" do
        get :show, id: notecard

        expect(response).to have_http_status(:ok)
      end

      it "responds with JSON" do
        get :show, id: notecard

        expect(response.content_type).to eq 'application/json'
      end

      it "succeeds" do
        get :show, id: notecard

        expect(response.body).to eq notecard.to_json
      end

      it "rescues from record not found error" do
        get :show, id: 1234

        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(404)
      end
    end
  end
end
