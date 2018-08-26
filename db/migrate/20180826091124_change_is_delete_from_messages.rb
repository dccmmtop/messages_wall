class ChangeIsDeleteFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :is_delete
    add_column :messages,:is_delete, :boolean,default: false
  end
end
