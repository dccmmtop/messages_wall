class AddCategoryToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :category, :string
  end
end
