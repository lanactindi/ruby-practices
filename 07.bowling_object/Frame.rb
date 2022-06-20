# frozen_string_literal: true

require './shot'

class Frame
  def initialize(first_mark, second_mark, third_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def first_and_second_score
    @first_shot.score + @second_shot.score
  end

  def all_third_score
    if first_and_second_score >= 10
      first_and_second_score + @third_shot.score
    else
      first_and_second_score
    end
  end
end
