require 'rails_helper'

RSpec.describe ThemesController, type: :controller do

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}
  let (:book) { Book.create(title: 'Book')}
  let (:book_attributes) { {book_attributes: {title: "a title"}} }
  let (:notecard) { Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book )}
  let (:theme) { Theme.create(name: 'Theme') }

  before(:each) do
    sign_in user
    theme.notecards << notecard
  end

  describe "GET #show" do
    it "responds successfully" do
      get :show, id: theme

      expect(response).to be_success
    end
  end
end
