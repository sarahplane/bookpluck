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

  describe "theme_list" do

    let(:book) { Book.create(title: "Some Title")}
    let(:notecard) { Notecard.create(title: "Some Title", quote: "Some Quote", book: book)}

    it "takes a string and creates themes" do
      notecard.theme_list=("theme1, theme2, theme3")
      expect(notecard.themes.pluck(:name)).to eq(["theme1", "theme2", "theme3"])
    end
  end
end
