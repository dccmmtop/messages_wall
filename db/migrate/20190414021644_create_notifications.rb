class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :admin_id
      t.text :content
      t.boolean :is_read , deafult: false
      t.boolean :is_delete, default: false

      t.timestamps
    end
  end
end
