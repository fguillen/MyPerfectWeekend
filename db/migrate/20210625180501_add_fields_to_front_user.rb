class AddFieldsToFrontUser < ActiveRecord::Migration[6.1]
  def change
    add_column :front_users, :age, :integer
    add_column :front_users, :country, :string
    add_column :front_users, :wannabe, :string
  end
end
