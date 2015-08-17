class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
