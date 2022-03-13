require './Frame.rb'

class Game
  def initialize(argv)
    @frames = split_frames(argv)
  end

  def calculate_score
    @frames.map.with_index { |frame, index| Frame.new(*frame).calculate_score }.sum
  end

  private

  def split_frames(argv)
    shots = argv.split(',').map { |shot| shot == 'X' ? 10 : shot.to_i }
    frames = []
    9.times do |index|
      frame = shots.shift(2)
      next_frame = shots.take(1)
      if frame.first == 10
        shots.unshift(frame.last)
        frames << [frame.first, 0, 0, frame[1], next_frame[0]]
      elsif frame.first + frame.last == 10
        frames << [frame.first, frame.last, next_frame[0]]
      else
        frames << frame
      end
    end
    frames << shots
  end
end