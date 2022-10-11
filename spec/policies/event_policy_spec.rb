require 'spec_helper'
require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: user) }

  subject { described_class }

  permissions :show? do
    it { is_expected.to permit(user, event) }
    it { is_expected.to permit(nil, event) }
  end

  permissions :create? do
    it { is_expected.to permit(user, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :update? do
    it { is_expected.to permit(user, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :destroy? do
    it { is_expected.to permit(user, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :index? do
    it { is_expected.to permit(user, event) }
    it { is_expected.to permit(nil, event) }
  end
end
