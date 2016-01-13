class AddConfirmedSleepingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmed, :integer
    add_column :users, :sleeping, :integer
  end
end
