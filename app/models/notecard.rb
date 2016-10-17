class Notecard < ActiveRecord::Base

  ## associations ##
  belongs_to :user, optional: true
  belongs_to :book
  accepts_nested_attributes_for :book
  has_many :quotations
  has_many :authors, through: :quotations
  accepts_nested_attributes_for :authors
  has_many :themings
  has_many :themes, through: :themings

  ## validations ##
  validates :title, presence: true, uniqueness: true, length: { maximum: 50,
    too_long: "50 characters is the max allowed"}
  validates :quote, presence: true, length: { maximum: 1500,
    too_long: "1500 characters is the maximum allowed"}

  ## methods ##

  def theme_list
    themes.pluck(:name).join(", ")
  end

  def theme_list=(theme_list)
    theme_names = theme_list.split(',').map{ |name| name.strip.downcase }.uniq
    new_or_found_themes = theme_names.map{ |name| Theme.find_or_create_by(name: name) }
    self.themes = new_or_found_themes
  end

  def author_name(attribute)
    self.authors.pluck(attribute)
    # TODO: this needs updating for multi-author support
  end

  def build_download_data(file_type)
    case file_type
    when "txt"
      data = "TITLE:\r======\r#{self.title}\r\r"
      data << "QUOTE:\r======\r#{self.quote}\r\r"
      data << "BOOK:\r=====\r#{self.book.title}\r\r"
      data << "NOTE:\r=====\r#{self.note}\r\r"
      data << "AUTHOR:\r=======\r#{self.authors[0].first_name} #{self.authors[0].last_name}\r\r"
      #TODO: Update this for multiple author support
      data << "THEMES:\r=======\r#{self.themes.map{|theme| theme.name}.join(", ")}\r\r"
      data << "CREATED:\r========\r#{self.created_at}\r"
    when "html"
      data = "<strong>TITLE:</strong><p>#{self.title}</p>\r\r"
      data << "<strong>QUOTE:</strong><p>#{self.quote}</p>\r"
      data << "<strong>BOOK:</strong><p>#{self.book.title}</p>\r\r"
      data << "<strong>NOTE:</strong><p>#{self.note}</p>\r\r"
      data << "<strong>AUTHOR:</strong><p>#{self.authors[0].first_name} #{self.authors[0].last_name}</p>\r\r"
      #TODO: Update this for multiple author support
      data << "<strong>THEMES:</strong><p>#{self.themes.map{|theme| theme.name}.join(", ")}</p>\r\r"
      data << "<strong>CREATED:</strong><p>#{self.created_at}</p>"
    end
  end
end
