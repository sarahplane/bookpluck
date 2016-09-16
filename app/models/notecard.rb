class Notecard < ActiveRecord::Base
  belongs_to :book
  accepts_nested_attributes_for :book

  has_many :quotations
  has_many :authors, through: :quotations
  accepts_nested_attributes_for :authors

  validates :title, presence: true, uniqueness: true
  validates :quote, presence: true, length: { maximum: 1500,
    too_long: "1500 characters is the maximum allowed"}
    # customizes the error message

  def author_names
    author_names = authors.join(', ')
  end

  def author_names=(author_names)
    author_names = author_list.split(', ')
    new_or_found_author = Author.find_or_create_by(last_name: "#{author_names[0]}", first_name: "#{author_names[1]}")
    self.authors << new_or_found_author
  end
end
