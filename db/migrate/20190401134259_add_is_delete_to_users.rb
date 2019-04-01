class AddIsDeleteToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_delete, :boolean, default: false
  end
end
