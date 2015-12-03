class Section < ActiveRecord::Base
  belongs_to :event
  has_many :departments
  has_many :positions, through: :departments
  has_many :users, through: :positions
end
