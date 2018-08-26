class AddLatitudeAndLongitudeToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :latitude, :float
    add_column :messages, :longitude, :float
  end
end
