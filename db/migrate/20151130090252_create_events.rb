class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :number
      t.datetime :date

      t.timestamps null: false
    end
  end
end
