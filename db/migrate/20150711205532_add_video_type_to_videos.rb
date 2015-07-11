class AddVideoTypeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_type, :integer
  end
end
