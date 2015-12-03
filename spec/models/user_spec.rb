require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :positions }
  it { is_expected.to have_many :recommendations }
  it { is_expected.to have_many :recommenders }
end
