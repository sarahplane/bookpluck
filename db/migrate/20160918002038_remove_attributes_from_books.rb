class RemoveAttributesFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :publisher
    remove_column :books, :editor
    remove_column :books, :isbn
    remove_column :books, :year_published
  end
end
