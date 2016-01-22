class User < ActiveRecord::Base
  has_many :event_users
  has_many :events, through: :event_users

  has_many :recommendations
  has_many :recommenders, through: :recommendations

  serialize :auth_meta_data
  serialize :image_meta_data

  scope :unconfirmed, -> { where('confirmed != 1') }
  scope :confirmed, -> { where(confirmed: 1) }
end
