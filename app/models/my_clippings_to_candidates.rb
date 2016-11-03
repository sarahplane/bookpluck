class MyClippingsToCandidates

  def initialize
    @candidate = {}
    @author = {}
    @candidates = []
  end

  def kindle_parser(file_content, user_id)
    @user_id = user_id
    parse(file_content)
    @candidates
  end

private

  def parse(file_content)
    clippings = file_content.force_encoding("UTF-8").split("=" * 10).delete_if{ |c| c.strip.empty? }

    clippings.reverse.each do |clipping|
      parse_lines(clipping)
    end
  end

  def parse_lines(clipping)
    lines = clipping.lines.delete_if{ |line| line.strip.empty? }.collect(&:strip)
    parse_type(lines) if lines.length == 3
  end

  def parse_type(lines)
    parse_quote(lines) if lines[1].include? "Highlight"
    parse_note(lines) if lines[1].include? "Note"
  end

  def parse_note(lines)
    @candidates[-1].note = lines[2] if @candidates.length > 0
  end

  def parse_quote(lines)
    @candidate[:quote] = lines[2]
    parse_author(lines)
  end

  def parse_author(lines)
    author_names = lines[0].reverse[/\).*?\(/].to_s.gsub(/[()]/, "").reverse
    if author_names.include? ","
      @author[:last_name], @author[:first_name] = author_names.split(",").collect(&:strip)
    else
      @author[:first_name], @author[:last_name] = author_names.split(" ", 2).collect(&:strip)
    end
    lines[0].slice!("(#{author_names})")
    parse_book(lines)
  end

  def parse_book(lines)
    book_title = lines[0]
    @candidate[:book] = Book.find_or_initialize_by(title: book_title)
    candidate_initializer
  end

  def candidate_initializer
    notecard = Notecard.new(@candidate)
    notecard.authors << Author.find_or_initialize_by(@author)
    @candidates << notecard
  end
end
