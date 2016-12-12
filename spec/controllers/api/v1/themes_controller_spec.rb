RSpec.describe Api::V1::ThemesController, type: :controller do
  let (:theme) { Theme.create(name: 'Theme') }
  let (:user) { User.create(email: "user@user.com",
                            password: "123456",
                            password_confirmation: "123456",
                            confirmed_at: Time.now) }

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
      theme
      get :index

      expect(response.body).to eq [theme].to_json
    end
  end

  describe "GET #show" do
    it "succeeds" do
      get :show, id: theme

      expect(response).to have_http_status(:ok)
    end

    it "responds with JSON" do
      get :show, id: theme

      expect(response.content_type).to eq 'application/json'
    end

    it "returns the correct data" do
      get :show, id: theme

      expect(response.body).to eq theme.to_json
    end

    it "rescues from record not found error" do
      get :show, id: 1234

      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:forbidden)
    end
  end
end
