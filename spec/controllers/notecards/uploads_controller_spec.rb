RSpec.describe Notecards::UploadsController, type: :controller do

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}

  before(:each) do
    sign_in user
  end

  describe "POST #create" do

    it "is successful" do
      file = fixture_file_upload('files/my_clippings.txt', 'text/plain')
      post :create, my_clippings: file

      expect(response.status).to eq 200
    end

    it "will redirect with an error without the my_clippings param" do
      post :create

      expect(response.status).to eq 302
    end

    it "will redirect to uploader upon failure" do
      post :create

      expect(response).to redirect_to(new_notecards_upload_path)
    end
  end
end
