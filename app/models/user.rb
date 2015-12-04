class User < ActiveRecord::Base
  has_many :positions

  has_many :recommendations
  has_many :recommenders, through: :recommendations

  serialize :auth_meta_data
end
