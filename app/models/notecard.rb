class Notecard < ActiveRecord::Base
  belongs_to :book
  accepts_nested_attributes_for :book

  validates :title, presence: true, uniqueness: true
  validates :quote, presence: true, length: { maximum: 1500,
    too_long: "1500 characters is the maximum allowed"}
    # customizes the error message
end
