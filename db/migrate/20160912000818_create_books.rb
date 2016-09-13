class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :publisher
      t.string :editor
      t.string :isbn
      t.integer :year_published

      t.timestamps
    end
  end
end
