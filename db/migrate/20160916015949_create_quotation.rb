class CreateQuotation < ActiveRecord::Migration[5.0]
  def change
    create_table :quotations do |t|
      t.references :author, index: true
      t.references :notecard, index: true

      t.timestamps
    end
  end
end
