class CreateWeekends < ActiveRecord::Migration[6.1]
  def change
    create_table :weekends, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :city, null: false
      t.text :body, null: false
      t.string :front_user_id

      t.timestamps
    end

    add_foreign_key :weekends, :front_users, column: :front_user_id, primary_key: "uuid"
  end
end
