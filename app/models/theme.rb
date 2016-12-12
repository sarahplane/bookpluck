class Theme < ActiveRecord::Base
  has_many :themings, dependent: :destroy
  has_many :notecards, through: :themings

  scope :alphabetized, -> { order(:name) }
end
