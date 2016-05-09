class CreateVideoViews < ActiveRecord::Migration[5.0]
  def change
    create_table :video_views do |t|
      t.belongs_to :video, null: false
      t.belongs_to :user, null: false
      t.timestamps null: false
    end
  end
end
