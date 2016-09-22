class AddUserToNotecards < ActiveRecord::Migration[5.0]
  def change
    add_reference :notecards, :user, foreign_key: true
  end
end
