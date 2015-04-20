class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.integer :move_id
      t.integer :video_id
      t.integer :minutes
      t.integer :seconds
    end
  end
end
