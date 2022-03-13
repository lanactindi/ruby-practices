require_relative "./Game.rb"

shots = ARGV[0]

game = Game.new(shots)

puts game.calculate_score