class CreateNotecards < ActiveRecord::Migration[5.0]
  def change
    create_table :notecards do |t|
      t.string :title
      t.text :quote

      t.timestamps
    end
  end
end
