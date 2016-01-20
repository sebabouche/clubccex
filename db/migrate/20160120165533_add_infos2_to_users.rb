class AddInfos2ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string
    add_column :users, :occupation, :string
    add_column :users, :phone, :string
    add_column :users, :city, :string
  end
end
