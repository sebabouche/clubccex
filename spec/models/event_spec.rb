require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to have_many :sections }
  it { is_expected.to have_many :departments }
  it { is_expected.to have_many :positions }
  it { is_expected.to have_many :users }
end
