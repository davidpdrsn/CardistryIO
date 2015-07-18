class AddTimestampsToMoves < ActiveRecord::Migration
  def change
    add_column :moves, :created_at, :datetime
    add_column :moves, :updated_at, :datetime
  end
end
