class Department < ActiveRecord::Base
  belongs_to :section
  has_many :positions
  has_many :users, through: :positions
end
