require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def category
    @category ||= Category.new
  end

  def test_valid
    assert category.valid?
  end
end
