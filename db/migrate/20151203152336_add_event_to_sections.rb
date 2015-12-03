class AddEventToSections < ActiveRecord::Migration
  def change
    add_reference :sections, :event, index: true, foreign_key: true
  end
end
