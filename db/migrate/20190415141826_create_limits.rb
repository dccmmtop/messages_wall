class CreateLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :limits do |t|
      t.integer :user_id
      t.integer :day
      t.string :reason
      t.integer :category

      t.timestamps
    end
  end
end
