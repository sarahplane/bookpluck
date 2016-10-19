require 'rails_helper'

RSpec.describe MyClippingsToNotecards, type: :module do

  include MyClippingsToNotecards

  let (:user) { User.create(email: "user@user.com", password: "123456", password_confirmation: "123456", confirmed_at: Time.now)}
  let (:book) { Book.create(title: 'Book')}

  describe "kindle_parser" do

    let (:file_content) { "Title (First Last)\r\n- Your Highlight on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n" }

    it "will create a notecard and return its id" do

      expect(kindle_parser(file_content, user.id)).to eq([1])
    end

    it "will assign the correct title" do
      kindle_parser(file_content, user.id)

      expect(user.notecards[0].quote).to eq("Test")
    end

    it "will add a notecard" do
      expect{ kindle_parser(file_content, user.id) }.to change{ Notecard.count }.by(+1)
    end

    it "can handle authors that display reversed separated by a comma" do
      file_content_with_comma = "Title (Last, First)\r\n- Your Highlight on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n"
      kindle_parser(file_content_with_comma, user.id)

      expect(Notecard.last.authors[0].first_name).to eq('First')
    end
  end

  context "notecard_updater when type is note" do

    let (:file_content) { "Title (First Last)\r\n- Your Note on page 29 | Location 441-443 | Added on Monday, October 10, 2016 4:02:45 PM\r\n\r\nTest\r\n==========\r\n" }

    it "will update the note" do
      notecard = Notecard.create(title: 'Notecard', quote: 'Quote', note: 'Note', book: book)

      expect{ kindle_parser(file_content, user.id) }.to change{ Notecard.last.note }.from('Note').to('Test')
    end
  end

end
