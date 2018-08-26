class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.text :content
      t.point :position
      t.integer :limit_user_accounts
      t.integer :limit_days
      t.boolean :is_delete

      t.timestamps
    end
  end
end
