class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :comments

  default_scope { order("created_at DESC")}

  scope :from_category, -> (category) { where('category_id = ?', category) }
end
