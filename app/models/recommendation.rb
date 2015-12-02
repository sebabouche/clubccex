class Recommendation < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :recommender, class_name: "User"
end
