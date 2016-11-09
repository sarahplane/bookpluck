class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :notecards
  before_create :generate_api_auth_token

  before_validation :assure_api_auth_token, unless: :new_record?
  validates :api_auth_token, presence: true, uniqueness: true, unless: :new_record?
  validate  :must_have_api_auth_token, unless: :new_record?


  def self.from_omniauth(auth)
    if auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]    # note: this is a random password
      end
    end
  end

private

  def generate_api_auth_token
    loop do
      self.api_auth_token = Devise.friendly_token(64)
      break unless User.find_by(api_auth_token: api_auth_token)
    end
  end

  def assure_api_auth_token
    generate_api_auth_token unless valid_api_auth_token?
  end

  def valid_api_auth_token?
    self.api_auth_token && (self.api_auth_token.length == 64)
  end

  def must_have_api_auth_token
    errors.add(:api_auth_token, 'is not valid') unless valid_api_auth_token?
  end
end
