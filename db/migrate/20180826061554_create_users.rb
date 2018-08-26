class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :ime
      t.string :nickname

      t.timestamps
    end
  end
end
