class User < ActiveRecord::Base
  has_many :event_users
  has_many :events, through: :event_users

  has_many :recommendations
  has_many :recommenders, through: :recommendations

  serialize :auth_meta_data
  serialize :image_meta_data

  scope :unconfirmed, -> { where('confirmed != 1') }
  scope :unconfirmed_sleeping, -> { where(confirmed: 0, sleeping: 1) }
  scope :confirmed, -> { where(confirmed: 1, sleeping: 0) }
  scope :confirmed_sleeping, -> { where(confirmed: 1, sleeping: 1) }

  default_scope { order('lastname, firstname') }
end
