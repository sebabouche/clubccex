class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :recommender_id

      t.timestamps null: false
    end

    add_index :recommendations, :user_id
    add_index :recommendations, :recommender_id
    add_index :recommendations, [:user_id, :recommender_id], unique: true
  end
end
