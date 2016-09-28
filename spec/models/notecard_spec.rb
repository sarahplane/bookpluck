require 'rails_helper'

RSpec.describe Notecard, type: :model do

  describe "validations" do

    let(:book) { Book.create(title: "Some Title")}
    let(:notecard) { Notecard.create(title: "Some Title", quote: "Some Quote", book: book)}

    it "is not valid without a title" do
      notecard.title = nil

      expect(notecard.valid?).to be(false)
    end

    it "is not valid with a non-unique title" do
      notecard.title = "Some Title"
      notecard2 = Notecard.create(title: "Some Title", quote: "Some Quote", book: book)

      expect(notecard2.valid?).to_not eq(true)
    end

    it "is not valid without a quote" do
      notecard.quote = nil
      notecard.valid?

      expect(notecard.errors[:quote]).to include("can't be blank")
    end

    it "is not valid with a quote longer than 1500" do
      notecard.quote = "a" * 1501

      expect(notecard.valid?).to eq(false)
    end
  end

  describe ".theme_list" do

    let(:book) { Book.create(title: "Some Title")}
    let(:notecard) { Notecard.create(title: "Some Title", quote: "Some Quote", book: book)}

    it "takes a string and assigns themes to a notecard" do
      notecard.theme_list=("theme1, theme2, theme3")

      expect(notecard.themes.pluck(:name)).to eq(["theme1", "theme2", "theme3"])
    end

    it "returns a string of a notecard's themes" do
      theme = Theme.create(name: "theme")
      theme2 = Theme.create(name: "theme2")
      theme_array = []
      theme_array << theme
      theme_array << theme2
      notecard.themes = theme_array

      expect(notecard.theme_list).to eq('theme, theme2')
    end
  end

  describe ".author_name" do

    let(:book) { Book.create(title: "Some Title")}
    let(:notecard) { Notecard.create(title: "Some Title", quote: "Some Quote", book: book)}

    it "returns the author's first name" do
      @author = Author.create(first_name: "First", last_name: "Last")
      author_array = []
      author_array << @author
      notecard.authors = author_array

      expect(notecard.author_name(:first_name)).to eq(["First"])
    end
  end
end
