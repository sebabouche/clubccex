class Event < ActiveRecord::Base
  has_many :sections
  has_many :departments, through: :sections
  has_many :positions, through: :departments
  has_many :users, through: :positions

  default_scope { order('number ASC') }
end
