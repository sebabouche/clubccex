class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :priority
      t.string :name
      t.string :icon
      t.string :library

      t.timestamps null: false
    end
  end
end
