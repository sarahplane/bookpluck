class MyClippingsParser
  def self.parser(file_contents, user_id)
    clippings = []
    clippings = file_contents.split("==========")

    count = 1

    clippings.pop if clippings[-1].strip.empty?
    # Kindle files have an extra line added at bottom

    clippings.each do |clipping|

      title_author_type_location = clipping.split("| Added on ")[0]
      # EXAMPLE: "This is the third title (Jeffrey Lucas)\r\n- Highlight Loc. 1004-5  "
      date_time_text = clipping.split("| Added on ")[1]
      # Included "Added on" to disclude | that shows up in time
      # EXAMPLE: "Monday, 3 December 12 22:52:42 GMT+00:00\r\n\r\nAd mea tamquam quaeque dolorem,"

      author_names = title_author_type_location.reverse[/\).*?\(/].to_s.gsub(/[()]/, "").reverse
      # Used reverses to insure that parentheses in the title are excluded

      text = date_time_text.split(/[\r\n\r\n]+/)[1]
      author_names_matcher = title_author_type_location[/\(.*?\)/]
      title_type_location_array = title_author_type_location.split("#{author_names_matcher}")
      title = title_type_location_array[0].strip

      type_location_array = title_type_location_array[1].to_s.split('Location')
      type_string = type_location_array[0].strip

      if type_string.include? "Highlight"
        type = "highlight"
      elsif type_string.include? "Note"
        type = "note"
      else
        next
        # handling for 'bookmark' type
      end

      location = type_location_array[1].strip

      if type == "highlight"
        book = Book.find_or_create_by(title: title)
        Notecard.create(title: "#{text[0..12]}...", quote: text, book: book, user_id: user_id)
        author = Author.find_or_create_by(first_name: "#{author_names.split(" ")[0]}", last_name: "#{author_names.split(" ")[1]}")
        Notecard.last.authors << author
      elsif type == "note"
        Notecard.last.update(note: "#{text}")
      end

      count += 1
    end
  end
end
