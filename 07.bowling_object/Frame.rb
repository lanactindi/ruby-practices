# frozen_string_literal: true

require './shot'

class Frame
  def initialize(first_shot, second_shot, third_shot = 0, next_shot = 0, after_next_shot = 0)
    @first_shot = Shot.new(first_shot).score
    @second_shot = Shot.new(second_shot).score
    @third_shot = Shot.new(third_shot).score
    @next_shot = Shot.new(next_shot).score
    @after_next_shot = Shot.new(after_next_shot).score
  end

  def calculate_score
    @frame_score = @first_shot
    @frame_score += @second_shot if @second_shot
    @frame_score += @third_shot if @third_shot
    @frame_score += @next_shot + @after_next_shot if frame_strike?
    @frame_score += @next_shot if frame_spare?
    @frame_score
  end

  def frame_strike?
    @first_shot == 10
  end

  def frame_spare?
    (@first_shot + @second_shot == 10) && !frame_strike?
  end
end
