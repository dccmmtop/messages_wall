class AddIsCommentToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :is_comment, :boolean, default: true
  end
end
