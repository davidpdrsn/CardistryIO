class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :type
      t.integer :actor_id
      t.boolean :seen, default: false
      t.timestamps
    end
  end
end
