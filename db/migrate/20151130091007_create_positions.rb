class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true
      t.boolean :president
      t.boolean :treasurer
      t.boolean :secretariat

      t.timestamps null: false
    end
  end
end
