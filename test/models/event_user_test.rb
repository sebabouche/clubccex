require "test_helper"

class EventUserTest < ActiveSupport::TestCase
  def event_user
    @event_user ||= EventUser.new
  end

  def test_valid
    assert event_user.valid?
  end
end
