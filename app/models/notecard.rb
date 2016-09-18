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
  validate :author_names_presence

  def author_names
    author_names = authors.join(' ')
  end

  def author_names=(author_names)
    if author_names == ''
      nil
    else
      first_name, last_name = author_names.split(' ', 2)
      new_or_found_author = Author.find_or_create_by(last_name: last_name, first_name: first_name)
      self.authors << new_or_found_author
    end
  end

  def author_names_presence
    if self.authors.empty?
      errors.add(:author_names, "must be present")
    end
  end
end
