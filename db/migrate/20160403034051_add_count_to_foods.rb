class AddCountToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :count, :integer, default: 0
  end
end
