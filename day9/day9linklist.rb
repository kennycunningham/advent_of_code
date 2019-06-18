#!/usr/bin/env ruby

require_relative "./circular_list.rb"

winning_score = 32
score = 0
num_players = 9
last_marble = 25
players = {}
marbles = []
marble_number = 0
current_marble = 0

list = CircularList.new
list.insert("0")

until marble_number > last_marble
  num_players.times do |player|
    players[player] = 0 if players[player].nil?
    break if marble_number > last_marble
    if marble_number == 1
      list.insert(marble_number)
      current_marble = marble_number
      marble_number += 1
    elsif (marble_number.to_f % 23) == 0
#      seven_back = list.search(current_marble) - 7
#      players[player] = players[player] + marble_number + marbles[seven_back]
#      marbles.delete_at(seven_back)
#      six_back = marbles.index(current_marble) - 6
#      current_marble = marbles[six_back]
#      marble_number += 1
    elsif list.search(current_marble) == list.head
       list.insert(
#      marbles.insert(1, marble_number)
#      current_marble = marble_number
#      marble_number += 1
#    else
#      marbles.insert((marbles.index(current_marble) + 2), marble_number)
#      current_marble = marble_number
#      marble_number += 1
    end
  end
end

puts list.head.data
puts list.head
