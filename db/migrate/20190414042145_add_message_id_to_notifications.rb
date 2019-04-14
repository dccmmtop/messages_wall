class AddMessageIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :message_id, :integer
  end
end
