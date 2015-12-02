class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.text :auth_meta_data

      t.timestamps null: false
    end
    add_index :users, :email
  end
end
