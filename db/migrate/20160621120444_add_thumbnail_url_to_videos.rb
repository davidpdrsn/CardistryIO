class AddThumbnailUrlToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :thumbnail_url, :string
  end
end
