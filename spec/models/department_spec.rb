require 'rails_helper'

RSpec.describe Department, type: :model do
  it { is_expected.to belong_to :section }
  it { is_expected.to have_many :positions }
  it { is_expected.to have_many :users }
end
