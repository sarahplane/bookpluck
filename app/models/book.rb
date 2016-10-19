class Book < ActiveRecord::Base
  has_many :notecards, dependent: :destroy
  has_many :authorings
  has_many :authors, through: :authorings

  validates :title, presence: true

  scope :has_notecards,-> { joins(:notecards).group('books.id') }
  scope :has_notecards_by_count,-> { joins(:notecards).group('books.id').order('COUNT(notecards.id) DESC') }
  scope :by_notecard_count,-> { left_joins(:notecards).group('books.id').order('COUNT(notecards.id) DESC') }
end
