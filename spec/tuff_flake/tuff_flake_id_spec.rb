# frozen_string_literal: true

RSpec.describe TuffFlake::TuffFlakeId do
  describe "#to_id" do
    context "when normal time" do
      subject { tuff_flake_id.to_id }

      let(:tuff_flake_id) do
        described_class.new(
          start_at: Time.parse("2021-01-01 00:00:00"),
          elapsed_time: 0,
          machine_id: 1,
          sequence: 0
        )
      end

      it "return integer id" do
        is_expected.to be_kind_of(Integer)
      end
    end

    context "when elapsed_time is over bit length" do
      let(:tuff_flake_id) do
        described_class.new(
          start_at: Time.parse("2021-01-01 00:00:00"),
          elapsed_time: 1 << TuffFlake::TuffFlakeId::BIT_LENGTH_ELAPSED_TIME,
          machine_id: 1,
          sequence: 0
        )
      end

      it "raise error" do
        expect { tuff_flake_id.to_id }.to raise_error(RuntimeError)
      end
    end
  end

  describe ".decompose" do
    let(:tuff_flake_id) do
      described_class.new(
        start_at: Time.parse("2021-01-01 00:00:00"),
        elapsed_time: rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_ELAPSED_TIME)),
        machine_id: rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_MACHINE_ID)),
        sequence: rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_SEQUENCE))
      )
    end
    let(:id) { tuff_flake_id.to_id }

    it "return decompose struct" do
      expect(described_class.decompose(id).elapsed_time).to eq tuff_flake_id.elapsed_time
      expect(described_class.decompose(id).machine_id).to eq tuff_flake_id.machine_id
      expect(described_class.decompose(id).sequence).to eq tuff_flake_id.sequence
    end
  end

  describe "#decompose" do
    let(:tuff_flake_id) do
      described_class.new(
        start_at: start_at,
        elapsed_time: elapsed_time,
        machine_id: rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_MACHINE_ID)),
        sequence: rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_SEQUENCE))
      )
    end
    let(:id) { tuff_flake_id.to_id }
    let(:start_at) { Time.parse("2021-01-01 00:00:00") }
    let(:elapsed_time) { rand(0...(1 << TuffFlake::TuffFlakeId::BIT_LENGTH_ELAPSED_TIME)) }

    it "return decompose struct" do
      expect(tuff_flake_id.decompose(id).created_at)
        .to eq Time.at((start_at.to_f + elapsed_time * TuffFlake::TuffFlakeId::TIME_UNIT).to_i)
      expect(tuff_flake_id.decompose(id).machine_id).to eq tuff_flake_id.machine_id
      expect(tuff_flake_id.decompose(id).sequence).to eq tuff_flake_id.sequence
    end
  end
end
