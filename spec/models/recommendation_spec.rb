require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :recommender }
end
