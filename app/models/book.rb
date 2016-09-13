class Book < ActiveRecord::Base
  has_many :notecards
end
