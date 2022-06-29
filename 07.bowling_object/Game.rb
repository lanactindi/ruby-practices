# frozen_string_literal: true

require_relative './frame'

FRAMES = 9

class Game
  def initialize(argv)
    @frames = split_frames(argv)
  end

  def calculate_score
    @frames.map(&:all_third_score).sum
  end

  private

  def split_frames(argv)
    shots = argv.split(',').map { |shot| Shot.new(shot).score }
    (0..FRAMES*2).map do |i|
      next if i.odd?
      shots.insert(i + 1, shots[i + 2]) if shots[i] == 10
      Frame.new(shots[i], shots[i + 1], shots[i + 2])
    end.compact
  end
end
