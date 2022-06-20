# frozen_string_literal: true

require './frame'

class Game
  def initialize(argv)
    @frames = split_frames(argv)
  end

  def calculate_score
    @frames.map(&:all_third_score).sum
  end

  private

  def split_frames(argv)
    shots = argv.split(',').map { |shot| shot == 'X' ? 10 : shot.to_i }
    frames = []
    (0..18).each do |i|
      if i.even?
        shots.insert(i + 1, shots[i + 2]) if shots[i] == 10
        frames << Frame.new(shots[i], shots[i + 1], shots[i + 2])
      end
    end
    frames
  end
end
