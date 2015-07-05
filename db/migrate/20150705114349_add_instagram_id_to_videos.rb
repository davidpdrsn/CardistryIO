class AddInstagramIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :instagram_id, :string
  end
end
