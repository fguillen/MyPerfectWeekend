class AddStatusToWeekend < ActiveRecord::Migration[6.1]
  def change
    add_column :weekends, :status, :string, limit: 32, null: false
  end
end
