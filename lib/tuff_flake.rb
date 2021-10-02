# frozen_string_literal: true

require "singleton"
require_relative "tuff_flake/version"
require_relative "tuff_flake/tuff_flake_id"

class TuffFlake
  include Singleton

  attr_reader :start_at, :machine_id

  class << self
    def setup(start_at:, machine_id:)
      instance.setup(start_at, machine_id)
    end

    def id
      instance.id
    end

    def decompose(value)
      instance.decompose(value)
    end

    def reset
      instance.reset
    end
  end

  def initialize
    @lock = Monitor.new
  end

  def setup(start_at, machine_id)
    raise("machine_id is not integer") unless machine_id.is_a?(Integer)
    if machine_id.negative? || machine_id >= (1 << TuffFlakeId::BIT_LENGTH_MACHINE_ID)
      raise("machine_id is out of range 0 <= machine_id < #{1 << TuffFlakeId::BIT_LENGTH_MACHINE_ID}}")
    end

    @start_at = start_at
    @machine_id = machine_id
  end

  def id
    lock.synchronize { tuff_flake_id.next_id }
  end

  def decompose(value)
    tuff_flake_id.decompose(value)
  end

  def reset
    @start_at = nil
    @machine_id = nil
    @tuff_flake_id = nil
  end

  private

  attr_reader :lock

  def tuff_flake_id
    @tuff_flake_id ||= begin
      raise("call setup") if start_at.nil? || machine_id.nil?

      TuffFlakeId.new(
        start_at: start_at,
        elapsed_time: 0,
        machine_id: machine_id,
        sequence: 0
      )
    end
  end
end
