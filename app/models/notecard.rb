class Notecard < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :book
  accepts_nested_attributes_for :book

  has_many :quotations
  has_many :authors, through: :quotations
  accepts_nested_attributes_for :authors

  has_many :themings
  has_many :themes, through: :themings

  validates :title, presence: true, uniqueness: true
  validates :quote, presence: true, length: { maximum: 1500,
    too_long: "1500 characters is the maximum allowed"}
    # customizes the error message

  def theme_list
    themes.join(', ')
  end

  def theme_list=(theme_list)
    theme_names = theme_list.split(',').map{|name| name.strip.downcase}.uniq
    new_or_found_themes = theme_names.map do |name|
      Theme.find_or_create_by(name: name)
    end
    self.themes = new_or_found_themes
  end
end
