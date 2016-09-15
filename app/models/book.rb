class Book < ActiveRecord::Base
  has_many :notecards

  validates :title, presence: true
end
