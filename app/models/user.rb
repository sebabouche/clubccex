class User < ActiveRecord::Base
  has_many :positions
  has_many :departments, through: :positions
  has_many :sections, through: :departments
  has_many :events, through: :sections

  has_many :recommendations
  has_many :recommenders, through: :recommendations

  serialize :auth_meta_data

  scope :unconfirmed, -> { where('confirmed != 1') }
  scope :confirmed, -> { where(confirmed: 1) }
end
