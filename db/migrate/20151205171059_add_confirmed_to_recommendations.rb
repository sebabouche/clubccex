class AddConfirmedToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :confirmed, :boolean
  end
end
