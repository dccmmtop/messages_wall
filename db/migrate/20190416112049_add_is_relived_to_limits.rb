class AddIsRelivedToLimits < ActiveRecord::Migration[5.1]
  def change
    add_column :limits, :is_relived, :boolean, default: false
    remove_column :limits, :category
  end
end
