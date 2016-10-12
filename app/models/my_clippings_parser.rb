class MyClippingsParser
  def self.parser(file_contents, user_id)
    clippings = []
    clippings = file_contents.split("==========")

    count = 1

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
      type_location_array = title_type_location_array[1].to_s.split(' Loc. ')
      type = type_location_array[0].strip
      location = type_location_array[1].strip

      book = Book.create(title: title)
      Notecard.create(title: "#{text[0..12]}...", quote: text, book: book, user_id: user_id)

      count += 1
    end
  end
end
