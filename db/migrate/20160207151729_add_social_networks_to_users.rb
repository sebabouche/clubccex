class AddSocialNetworksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :linkedin, :string
    add_column :users, :twitter, :string
  end
end