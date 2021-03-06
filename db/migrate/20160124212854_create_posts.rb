class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.boolean :closed
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
