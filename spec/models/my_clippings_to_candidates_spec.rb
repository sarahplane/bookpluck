require 'rails_helper'

RSpec.describe MyClippingsToCandidates, type: :model do

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}
  let (:book) { Book.create(title: 'Book')}

  context "kindle_parser" do

    subject (:file_content) { "Title (First Last)\r\n- Your Highlight on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n" }
    subject (:candidates) { MyClippingsToCandidates.new.kindle_parser(file_content, user.id) }

    it "will create a candidate and return it in an array" do
      expect(candidates.count).to eq(1)
    end

    it "will leave the title as nil" do
      expect(candidates[0].title).to be nil
    end

    it "will add the correct quote" do
      expect(candidates[0].quote).to eq('Test')
    end

    it "can handle authors that display reversed separated by a comma" do
      file_content_with_comma = "Title (Last, First)\r\n- Your Highlight on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n"
      candidates_alt = MyClippingsToCandidates.new.kindle_parser(file_content_with_comma, user.id)

      expect(candidates_alt.first.authors.first.first_name).to eq('First')
    end
  end

  context "parse_note when type is note" do

    subject (:file_content) { "Title (First Last)\r\n- Your Note on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\nTitle (Last, First)\r\n- Your Highlight on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n" }
    subject (:candidates) { MyClippingsToCandidates.new.kindle_parser(file_content, user.id) }

    it "will update the note" do
      notecard = Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book)

      expect(candidates.first.note).to eq('Test')
    end
  end

end
