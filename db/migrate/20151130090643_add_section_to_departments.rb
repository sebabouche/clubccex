class AddSectionToDepartments < ActiveRecord::Migration
  def change
    add_reference :departments, :section, index: true, foreign_key: true
  end
end
