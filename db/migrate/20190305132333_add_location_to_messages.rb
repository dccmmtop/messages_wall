class AddLocationToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :location, :string
  end
end
