class AddIdeaToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :idea, :boolean, null: false, default: false
  end
end
