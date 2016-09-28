require 'rails_helper'

RSpec.describe Authoring, type: :model do
  it { is_expected.to belong_to(:author)}
  it { is_expected.to belong_to(:book)}
end
