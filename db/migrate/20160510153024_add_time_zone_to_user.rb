class AddTimeZoneToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :time_zone, :string, null: true

    User.all.each do |user|
      user.update!(time_zone: "UTC")
    end

    change_column_null :users, :time_zone, false
  end

  def down
    remove_column :users, :time_zone
  end
end
