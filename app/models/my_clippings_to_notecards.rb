module MyClippingsToNotecards

  def kindle_parser(file_content, user_id)
    @ids = []
    @count = 0
    @user_id = user_id

    parse(file_content)

    @ids
  end

private

  def parse(file_content)
    clippings = file_content.force_encoding("UTF-8").split("==========")

    clippings.pop if clippings[-1].strip.empty?
    # Removes the blank entry created by an empty ending line in the file

    clippings.each do |clipping|

      parse_clipping(clipping)

      @count += 1
    end
  end

  def parse_clipping(clipping)
    first_section, second_section = clipping.split("| Added on ")

    author_names = first_section.reverse[/\).*?\(/].to_s.gsub(/[()]/, "").reverse

    text = second_section.split(/[\r\n\r\n]+/)[1]

    book_title, type_location = first_section.split("(#{author_names})").map{ |t| t.strip }

    type, location = type_location.to_s.split('Location').compact.collect(&:strip)

    if type.include? "Highlight"

      notecard_builder(author_names, text, book_title, location)

    elsif type.include? "Note"

      notecard_updater(text)

    end
  end

  def notecard_builder(author_names, text, book_title, location)
    notecard = Notecard.create(title: "#{text[0..24]} #{@count}...", quote: text, book: Book.find_or_create_by(title: book_title), user_id: @user_id)

    if author_names.include? ","
      last_name, first_name = author_names.split(",").compact.collect(&:strip)
    else
      first_name, last_name = author_names.split(" ", 2).compact.collect(&:strip)
    end

    author = Author.find_or_create_by(first_name: (first_name if !first_name.nil?), last_name: (last_name if !first_name.nil?))

    notecard.authors << author

    @ids << notecard.id if notecard.save == true
  end

  def notecard_updater(text)
    Notecard.last.update(note: "#{text}")
  end
end
