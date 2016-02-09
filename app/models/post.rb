class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :comments, dependent: :destroy

  default_scope { order("closed ASC, created_at DESC")}

  scope :from_category, -> (category) { where('category_id = ?', category) }
end
