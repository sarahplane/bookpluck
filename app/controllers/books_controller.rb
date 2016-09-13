class BooksController < ApplicationController
  def create
    @notecard = Notecard.find(params[:notecard_id])
    @book = Book.new(book_params)
    @book.notecard = @notecard
  end
private
  def book_params
    params.require(:book).permit(:title, :publisher, :editor, :isbn, :year_published, :timestamp)
  end
end
