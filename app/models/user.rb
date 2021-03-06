class User < ActiveRecord::Base
  has_many :event_users, dependent: :destroy
  has_many :events, through: :event_users

  has_many :recommendations, dependent: :destroy
  has_many :recommenders, through: :recommendations

  has_many :pending_confirmations, -> { where confirmed: nil or false }, class_name: 'Recommendation',
    foreign_key: 'recommender_id'

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy

  serialize :auth_meta_data
  serialize :image_meta_data

  scope :unconfirmed, -> { where(confirmed: 0) }
  scope :unconfirmed_sleeping, -> { where(confirmed: 0, sleeping: 1) }
  scope :confirmed, -> { where(confirmed: 1, sleeping: 0) }
  scope :confirmed_sleeping, -> { where(confirmed: 1, sleeping: 1) }

  default_scope { order('lastname, firstname') }
end
