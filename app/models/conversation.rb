class Conversation < ActiveRecord::Base
  has_many :users
  has_many :messages
end
