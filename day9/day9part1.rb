#!/usr/bin/env ruby

winning_score = 146373
score = 0
num_players = 446
last_marble = 71522
players = {}
marbles = []
marble_number = 0
current_marble = 0

marbles << marble_number
current_marble = marble_number
marble_number += 1

until marble_number > last_marble
  num_players.times do |player|
    players[player] = 0 if players[player].nil?
    break if marble_number > last_marble
    if marbles.count == 1
      marbles << marble_number
      current_marble = marble_number
      marble_number += 1
    elsif (marble_number.to_f % 23) == 0
      seven_back = marbles.index(current_marble) - 7
      players[player] = players[player] + marble_number + marbles[seven_back]
      marbles.delete_at(seven_back)
      six_back = marbles.index(current_marble) - 6
      current_marble = marbles[six_back]
      marble_number += 1
    elsif marbles.index(current_marble) == (marbles.count - 1)
      marbles.insert(1, marble_number)
      current_marble = marble_number
      marble_number += 1
    else
      marbles.insert((marbles.index(current_marble) + 2), marble_number)
      current_marble = marble_number
      marble_number += 1
    end
  end
end

high_score = 0
high_player = 0
players.each do |player, score|
  if score > high_score
    high_player = player
    high_score = score
  end
end

puts "Winning player: #{high_player}: #{high_score}"
