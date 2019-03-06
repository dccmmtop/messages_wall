class AddReadCountsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :read_count, :integer, default: 0
  end
end
