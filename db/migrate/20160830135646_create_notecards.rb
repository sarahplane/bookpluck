class CreateNotecards < ActiveRecord::Migration[5.0]
  def change
    create_table :notecards do |t|
      t.string :title
      t.text :quote
      t.text :note
      t.references :book, index: true, foreign_key: true

      t.timestamps
    end
  end
end
