class AddIsDeleteToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :is_delete, :boolean, default: false
  end
end
