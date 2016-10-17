class MyClippingsToNotecards

  def self.parser(file_contents, user_id)

    @ids = []
    count = 1

    clippings = file_contents.force_encoding("UTF-8").split("==========")
    clippings.pop if clippings[-1].strip.empty?
    # Remove the My Clippings blank entry created by a blank ending line

    clippings.each do |clipping|

      title_author_type_location = clipping.split("| Added on ")[0]
      # EXAMPLE: "\r\nThe Count of Monte Cristo (Alexandre Dumas)\r\n- Your Highlight on page 30 | Location 453 "
      date_time_text = clipping.split("| Added on ")[1]
      # EXAMPLE: "Monday, October 10, 2016 4:05:03 PM\r\n\r\nTo learn is not to know.\r\n"
      author_names = title_author_type_location.reverse[/\).*?\(/].to_s.gsub(/[()]/, "").reverse
      text = date_time_text.split(/[\r\n\r\n]+/)[1]
      author_names_matcher = title_author_type_location.reverse[/\).*?\(/].to_s.reverse
      title_type_location_array = title_author_type_location.split("#{author_names_matcher}")
      title = title_type_location_array[0].strip
      type_location_array = title_type_location_array[1].to_s.split('Location')
      type_string = type_location_array[0].strip
      location = type_location_array[1].strip

      if type_string.include? "Highlight"
        notecard = Notecard.create(title: "#{text[0..24]} #{count}...", quote: text, book: Book.find_or_create_by(title: title), user_id: user_id)
        next if notecard.save == false
        author = Author.find_or_create_by(first_name: "#{author_names.split(" ")[0]}", last_name: "#{author_names.split(" ")[1]}")
        notecard.authors << author
        @ids << notecard.id
      elsif type_string.include? "Note"
        Notecard.last.update(note: "#{text}")
      else
        next
        # handling for 'bookmark' type
      end

      count += 1
    end

    @ids
  end
end
