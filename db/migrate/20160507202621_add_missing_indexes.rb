class AddMissingIndexes < ActiveRecord::Migration
  def change
    change_column_null :activities, :subject_id, false
    change_column_null :activities, :subject_type, false
    change_column_null :activities, :user_id, false
    add_index :activities, :user_id
    add_index :activities, [:subject_id, :subject_type]

    change_column_null :appearances, :video_id, false
    change_column_null :appearances, :move_id, false
    add_index :appearances, :move_id
    add_index :appearances, :video_id

    change_column_null :comments, :commentable_id, false
    change_column_null :comments, :commentable_type, false
    change_column_null :comments, :user_id, false
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id

    change_column_null :credits, :creditable_id, false
    change_column_null :credits, :creditable_type, false
    change_column_null :credits, :user_id, false
    add_index :credits, [:creditable_id, :creditable_type]
    add_index :credits, :user_id

    change_column_null :moves, :name, false
    change_column_null :moves, :user_id, false
    add_index :moves, :user_id
    add_index :moves, :name, unique: true

    change_column_null :notifications, :user_id, false
    change_column_null :notifications, :subject_id, false
    change_column_null :notifications, :subject_type, false
    change_column_null :notifications, :actor_id, false
    change_column_null :notifications, :notification_type, false
    change_column_null :notifications, :seen, false
    add_index :notifications, [:subject_id, :subject_type]
    add_index :notifications, :actor_id

    change_column_null :ratings, :rating, false
    change_column_null :ratings, :rateable_id, false
    change_column_null :ratings, :rateable_type, false
    change_column_null :ratings, :user_id, false
    add_index :ratings, :rating
    add_index :ratings, [:rateable_id, :rateable_type]
    add_index :ratings, :user_id

    change_column_null :relationships, :follower_id, false
    change_column_null :relationships, :followee_id, false
    change_column_null :relationships, :active, false
    add_index :relationships, :followee_id
    add_index :relationships, :follower_id

    change_column_null :sharings, :video_id, false
    change_column_null :sharings, :user_id, false
    add_index :sharings, :video_id
    add_index :sharings, :user_id

    change_column_null :users, :username, false
    change_column_null :users, :admin, false
    add_index :users, :username, unique: true
    add_index :users, :instagram_username, unique: true

    change_column_null :videos, :name, false
    change_column_null :videos, :user_id, false
    change_column_null :videos, :video_type, false
    change_column_null :videos, :url, false
    change_column_null :videos, :approved, false
    change_column_null :videos, :private, false
    add_index :videos, :user_id
    add_index :videos, :name

    [
      :activities,
      :comments,
      :credits,
      :moves,
      :notifications,
      :ratings,
      :relationships,
      :sharings,
      :users,
      :videos,
    ].each do |table|
      change_column_null table, :created_at, false
      change_column_null table, :updated_at, false
    end
  end
end
