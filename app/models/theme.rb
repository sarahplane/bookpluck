class Theme < ActiveRecord::Base
  has_many :themings
  has_many :notecards, through: :themings
end
