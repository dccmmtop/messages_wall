class AddPasswordDegistToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_degist, :string
    add_column :users, :admin, :boolean
  end
end
