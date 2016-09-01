class AddEmailFrequencyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_frequency, :integer, default: 0, null: false
  end
end
