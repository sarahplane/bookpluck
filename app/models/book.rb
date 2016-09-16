class Book < ActiveRecord::Base
  has_many :notecards
  has_many :authorings
  has_many :authors, through: :authorings
  
  validates :title, presence: true
end
