require 'rails_helper'

RSpec.describe ThemesController, type: :controller do

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
    @theme = Theme.create(name: 'Theme')
    @theme.notecards << @notecard
  end

  describe "GET #show" do
    it "responds successfully" do
      get :show, id: @theme

      expect(response).to be_success
    end
  end
end
