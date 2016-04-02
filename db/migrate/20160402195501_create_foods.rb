class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.boolean :available, default: false
      t.text :dining_halls, array: true, default: []
      t.text :meals, array: true, default: []
      t.timestamps
    end
  end
end
