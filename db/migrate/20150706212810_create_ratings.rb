class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.belongs_to :rateable, polymorphic: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
