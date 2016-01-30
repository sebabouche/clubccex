class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  scope :from_category, -> (category) { where('category_id = ?', category) }
end
