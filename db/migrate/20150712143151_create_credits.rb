class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.belongs_to :creditable, polymorphic: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
