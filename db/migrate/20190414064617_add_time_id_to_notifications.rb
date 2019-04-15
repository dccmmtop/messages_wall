class AddTimeIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :time_id, :integer
  end
end
