# frozen_string_literal: true

require "ostruct"
require "time"

class TuffFlake
  class TuffFlakeId
    BIT_LENGTH_SEQUENCE = 12
    BIT_LENGTH_MACHINE_ID = 10
    BIT_LENGTH_ELAPSED_TIME = 41
    TIME_UNIT = 0.001 # 1ms

    attr_accessor :start_at, :elapsed_time, :machine_id, :sequence

    def self.decompose(value)
      OpenStruct.new(
        elapsed_time: value >> (BIT_LENGTH_MACHINE_ID + BIT_LENGTH_SEQUENCE),
        machine_id: (value >> BIT_LENGTH_SEQUENCE) & ((1 << BIT_LENGTH_MACHINE_ID) - 1),
        sequence: value & ((1 << BIT_LENGTH_SEQUENCE) - 1)
      )
    end

    def initialize(start_at:, elapsed_time:, machine_id:, sequence:)
      @start_at = start_at
      @elapsed_time = elapsed_time
      @machine_id = machine_id
      @sequence = sequence
    end

    def next_id
      current_elapsed_time = ((Time.now.to_f - start_at.to_f) / TIME_UNIT).to_i
      if elapsed_time < current_elapsed_time
        self.elapsed_time = current_elapsed_time
        self.sequence = 0
      else
        self.sequence = (sequence + 1) & ((1 << BIT_LENGTH_SEQUENCE) - 1)
        if sequence.zero?
          self.elapsed_time = elapsed_time + 1
          overtime = elapsed_time - current_elapsed_time
          sleep(overtime * TIME_UNIT)
        end
      end

      to_id
    end

    def to_id
      raise("time over") if elapsed_time >= (1 << BIT_LENGTH_ELAPSED_TIME)

      (elapsed_time << (BIT_LENGTH_MACHINE_ID + BIT_LENGTH_SEQUENCE)) \
        | (machine_id << BIT_LENGTH_SEQUENCE) \
        | sequence
    end

    def decompose(value)
      result = self.class.decompose(value)
      OpenStruct.new(
        created_at: Time.at((start_at.to_f + result.elapsed_time * TIME_UNIT).to_i),
        machine_id: result.machine_id,
        sequence: result.sequence
      )
    end
  end
end
