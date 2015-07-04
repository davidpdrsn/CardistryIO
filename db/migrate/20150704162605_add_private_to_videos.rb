class AddPrivateToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :private, :boolean, default: false
  end
end
