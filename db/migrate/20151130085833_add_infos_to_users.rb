class AddInfosToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :maidenname, :string
    add_column :users, :nickname, :string
  end
end
