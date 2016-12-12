RSpec.describe Notecards::DownloadsController, type: :controller do

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}
  let (:book) { Book.create(title: 'Book')}
  let (:book_attributes) { {book_attributes: {title: "a title"}} }
  let (:notecard) { Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book )}

  before(:each) do
    sign_in user
  end

  describe "POST #create" do
    it "is successful with format: text" do
      post :create, notecard_id: notecard.id, format: "text"

      expect(response).to have_http_status(:ok)
    end

    it "is successful with format: html" do
      post :create, notecard_id: notecard.id, format: "html"

      expect(response).to have_http_status(:ok)
    end
  end
end
