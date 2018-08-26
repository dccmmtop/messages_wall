class RemovePositionFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages,:position
  end
end
