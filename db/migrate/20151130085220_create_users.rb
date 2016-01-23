class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email

      t.string :firstname
      t.string :lastname

      t.boolean :admin
      t.integer :confirmed
      t.integer :sleeping
      
      t.string :maidenname
      t.string :nickname
      t.string :gender
      t.string :company, :string
      t.string :occupation, :string
      t.string :phone, :string
      t.string :city, :string

      t.text :image_meta_data
      t.text :auth_meta_data


      t.timestamps null: false
    end
    add_index :users, :email
  end
end
