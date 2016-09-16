class Author < ActiveRecord::Base
  has_many :authorings
  has_many :books, through: :authorings

  has_many :quotations
  has_many :notecards, through: :quotations
end
