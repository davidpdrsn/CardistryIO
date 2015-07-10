class AddActiveToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :active, :boolean, default: true
  end
end
