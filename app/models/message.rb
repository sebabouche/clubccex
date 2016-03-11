class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation

  has_many :message_users
  has_many :users, through: :message_users
end
