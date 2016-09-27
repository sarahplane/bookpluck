class CreateTheming < ActiveRecord::Migration[5.0]
  def change
    create_table :themings do |t|
      t.references :notecard, index: true
      t.references :theme, index: true

      t.timestamps
    end
  end
end
