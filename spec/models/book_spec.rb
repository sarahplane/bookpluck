require 'rails_helper'

RSpec.describe Notecard, type: :model do

  context "#title" do
    
    let (:book) {Book.create(title: nil)}

    it "must be present" do
      expect(book.valid?).to eq(false)
    end

    it "returns an error when omitted" do
      expect(book.errors[:title]).to include("can't be blank")
    end

    it "accepts a valid title" do
      book.title = "Some Title"

      expect(book.valid?).to eq(true)
    end
  end
end
