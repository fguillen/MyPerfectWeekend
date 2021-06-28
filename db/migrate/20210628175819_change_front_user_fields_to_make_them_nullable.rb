class ChangeFrontUserFieldsToMakeThemNullable < ActiveRecord::Migration[6.1]
  def up
    change_column :front_users, :name, :string, null: true
    change_column :front_users, :email, :string, null: true
  end
end
