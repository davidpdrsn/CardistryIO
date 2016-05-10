class AddCountryCodeToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :country_code, :string, null: true

    User.all.each do |user|
      user.update!(country_code: "DK")
    end

    change_column_null :users, :country_code, false
  end

  def down
    remove_column :users, :country_code
  end
end
