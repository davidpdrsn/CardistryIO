class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.string :name
      t.text :description
      t.integer :user_id
    end
  end
end
