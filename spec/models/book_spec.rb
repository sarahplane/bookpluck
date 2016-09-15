require 'rails_helper'

RSpec.describe Notecard, type: :model do
  describe "#title" do
    it "is expected to be required" do
      book = Book.create(title: nil)
      expect(book.valid?).to eq(false)
      expect(book.errors[:title]).to include("can't be blank")

      book.title = "Some Title"
      expect(book.valid?).to eq(true)
    end
  end

  # rewritten with shoulda-matchers gem
  describe "#title" do
    it { is_expected.to validate_presence_of(:title) }
  end
end
