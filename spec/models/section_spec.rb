require 'rails_helper'

RSpec.describe Section, type: :model do
  it { is_expected.to belong_to :event }
  it { is_expected.to have_many :departments }
  it { is_expected.to have_many :positions }
  it { is_expected.to have_many :users }
end
