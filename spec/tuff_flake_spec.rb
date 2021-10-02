# frozen_string_literal: true

RSpec.describe TuffFlake do
  describe ".id" do
    subject { described_class.id }

    after { described_class.reset }

    context "call id after setup" do
      before { described_class.setup(start_at: Time.parse("2021-01-01 00:00:00"), machine_id: 1) }
      it { is_expected.to be_kind_of(Integer) }
    end

    context "call id before setup" do
      it { expect { described_class.id }.to raise_error(RuntimeError) }
    end
  end
end
