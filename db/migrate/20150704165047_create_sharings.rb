class CreateSharings < ActiveRecord::Migration
  def change
    create_table :sharings do |t|
      t.references :video
      t.references :user
      t.timestamps
    end
  end
end
