#!/usr/bin/env ruby

@current_state = '######....##.###.#..#####...#.#.....#..#.#.##......###.#..##..#..##..#.##..#####.#.......#.....##..'
300.times do |add_to_state|
  @current_state = '.' + @current_state + '.'
end

def node_rules(node_points)
  case node_points
  when '...##'
    return '#'
  when '##.#.'
    return '#'
  when '##...'
    return '#'
  when '#..#.'
    return '#'
  when '.##.#'
    return '#'
  when '..###'
    return '#'
  when '..#.#'
    return '#'
  when '.####'
    return '#'
  when '.#..#'
    return '#'
  when '####.'
    return '#'
  when '#.###'
    return '#'
  when '.#...'
    return '#'
  else
    return '.'
  end
end

def plant_logic(nodes_state, node_pos)
  node_rules(@current_state[(node_pos - 2)..(node_pos + 2)])
end

# puts "0: #{@current_state}"
50000000000.times do |i|
  tmp_state = ''
  @current_state.length.times do |plant|
    tmp_state = tmp_state + plant_logic(@current_state, plant)
  end
#  puts "#{i + 1}: #{tmp_state}"
  @current_state = tmp_state.dup
end

plant_counter = 0
@current_state.split("").each_index do |pot_index|
  if @current_state[pot_index] == '#'
    plant_counter = pot_index + plant_counter - 300
  end
end
puts "my current pot count: #{plant_counter}"
