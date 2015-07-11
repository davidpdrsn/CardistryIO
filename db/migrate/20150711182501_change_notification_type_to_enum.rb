class ChangeNotificationTypeToEnum < ActiveRecord::Migration
  def change
    drop_table :notification_types
    remove_column :notifications, :type_id, :integer
    add_column :notifications, :notification_type, :integer
  end

  def down
    create_table :notification_types do |t|
      t.string :name
    end
    add_column :notifications, :type_id, :integer
    remove_column :notifications, :notification_type, :integer
  end
end
