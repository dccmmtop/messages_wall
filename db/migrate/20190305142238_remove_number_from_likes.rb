class RemoveNumberFromLikes < ActiveRecord::Migration[5.1]
  def change
    remove_column :likes, :number
  end
end
