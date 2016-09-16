class CreateAuthoring < ActiveRecord::Migration[5.0]
  def change
    create_table :authorings do |t|
      t.references :author, index: true
      t.references :book, index: true

      t.timestamps
    end
  end
end
