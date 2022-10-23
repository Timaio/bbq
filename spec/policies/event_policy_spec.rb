require 'spec_helper'
require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let(:author) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: author) }
  let(:pundit_author) { UserContext.new(author, {}, nil) }
  let(:pundit_guest) { UserContext.new(guest, {}, nil) }

  let(:guest) { FactoryBot.create(:user) }
  let(:event_with_pincode) { FactoryBot.create(:event, user: author, pincode: "000") }
  let(:pundit_guest_with_correct_pincode) { UserContext.new(guest, {}, "000") }
  let(:pundit_guest_with_wrong_pincode) { UserContext.new(guest, {}, "x") }
  let(:pundit_guest_with_correct_cookies_pincode) do
    UserContext.new(guest, {"event_#{event_with_pincode.id}_pincode" => '000'}, nil)
  end
  let(:pundit_guest_with_wrong_cookies_pincode) do
    UserContext.new(guest, {"event_#{event_with_pincode.id}_pincode" => 'x'}, nil)
  end

  subject { described_class }

  permissions :show? do
    it { is_expected.to permit(pundit_author, event) }
    it { is_expected.to permit(pundit_guest, event) }

    context 'when event has a pincode' do
      it { is_expected.to permit(pundit_author, event_with_pincode) }
      it { is_expected.to permit(pundit_guest_with_correct_pincode, event_with_pincode) }
      it { is_expected.to permit(pundit_guest_with_correct_cookies_pincode, event_with_pincode) }

      it { is_expected.not_to permit(pundit_guest, event_with_pincode) }
      it { is_expected.not_to permit(pundit_guest_with_wrong_pincode, event_with_pincode) }
      it { is_expected.not_to permit(pundit_guest_with_wrong_cookies_pincode, event_with_pincode) }
    end
  end

  permissions :create? do
    it { is_expected.to permit(pundit_guest, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :update? do
    it { is_expected.to permit(pundit_author, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :destroy? do
    it { is_expected.to permit(pundit_author, event) }
    it { is_expected.not_to permit(nil, event) }
  end

  permissions :index? do
    it { is_expected.to permit(pundit_guest, event) }
    it { is_expected.to permit(nil, event) }
  end
end
