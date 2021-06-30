class InitWeekendsStatus < ActiveRecord::Migration[6.1]
  def up
    Weekend.all.update_all(status: "moderation_pending")
  end
end
