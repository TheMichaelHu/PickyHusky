class CreateFoodsUsersJoin < ActiveRecord::Migration
  def change
    create_table :foods_users, id: false do |t|
      t.integer :food_id
      t.integer :user_id
    end
    add_index :foods_users, [:food_id, :user_id]
  end
end
