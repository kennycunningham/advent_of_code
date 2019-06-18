#!/usr/bin/env ruby

require 'pp'
@debug = true

@cave_map = []
@unit_map = {}

def determine_order
  unit_order = []
  @unit_map.keys.each { |unit| unit_order << unit.to_i }
  swapped = true
  until swapped == false
    swapped = false
    unit_order.each_index do |comp1|
      if comp1 == (unit_order.length - 1)
        next
      elsif @unit_map[unit_order[comp1]][:y_axis] > @unit_map[unit_order[comp1 + 1]][:y_axis]
        unit_order[comp1], unit_order[comp1 + 1] = unit_order[comp1 + 1], unit_order[comp1]
        swapped = true
      elsif @unit_map[unit_order[comp1]][:y_axis] == @unit_map[unit_order[comp1 + 1]][:y_axis]
        if @unit_map[unit_order[comp1]][:x_axis] > @unit_map[unit_order[comp1 + 1]][:x_axis]
          unit_order[comp1], unit_order[comp1 + 1] = unit_order[comp1 + 1], unit_order[comp1]
          swapped = true
        end
      end
    end
  end
  return unit_order
end

def reset_cavemap
  @cave_map.each_index do |x_axis|
    @cave_map[x_axis].each_index do |map_point|
      if @cave_map[x_axis][map_point] == 'G'
        @cave_map[x_axis][map_point] = '.'
      elsif @cave_map[x_axis][map_point] == 'E'
        @cave_map[x_axis][map_point] = '.'
      end
    end
  end
end

def fill_in_cavemap
  reset_cavemap
  @unit_map.each do |id, unit_details|
    u = unit_details
    @cave_map[u[:y_axis]][u[:x_axis]] = u[:unit]
  end
end

def move_left(unit_y, unit_x)
  return true if @cave_map[unit_y][unit_x - 1] == '.'
end

def move_right(unit_y, unit_x)
  return true if @cave_map[unit_y][unit_x + 1] == '.'
end

def move_down(unit_y, unit_x)
  return true if @cave_map[unit_y + 1][unit_x] == '.'
end

def move_up(unit_y, unit_x)
  return true if @cave_map[unit_y - 1][unit_x] == '.'
end

def enemy_reachable(enemy_id)
  e = @unit_map[enemy_id]
  return true if move_right(e[:y_axis], e[:x_axis])
  return true if move_left(e[:y_axis], e[:x_axis])
  return true if move_up(e[:y_axis], e[:x_axis])
  return true if move_down(e[:y_axis], e[:x_axis])
  return false
end

def point_map(unit_id, enemy_id)
  row = @cave_map.length
  col = @cave_map[0].length
  point_map = Array.new(row) { Array.new(col) }
  @cave_map.each_index do |y_point|
    @cave_map[y_point].each_index do |x_point|
      y_score = (y_point - @unit_map[enemy_id][:y_axis]).abs
      x_score = (x_point - @unit_map[enemy_id][:x_axis]).abs
      point_map[y_point][x_point] = y_score + x_score
      point_map[y_point][x_point] = @cave_map[y_point][x_point] unless @cave_map[y_point][x_point] == '.'
    end
  end
#  @possible_steps = {}
#  u = @unit_map[unit_id].dup
#  if move_(u[:y_axis], u[:x_axis]) && 
end

def check_distance(unit_id, enemy_id)
  possible_steps = []
  possible_steps = possible_paths(unit_id, enemy_id)
  return steps
end

def closest_enemy(unit_id)
  attacker = @unit_map[unit_id]
  if attacker[:unit] == 'G'
    enemy_type = 'E'
  elsif attacker[:unit] == 'E'
    enemy_type = 'G'
  end
  enemy_array = []
  @unit_map.each do |id, unit_details|
    enemy_array << id if unit_details[:unit] == enemy_type
  end
  best_steps = []
  best_enemy = nil
  stuck_steps = []
  stuck_enemy = nil
  # sleep 1 if @debug
  enemy_array.each do |enemy_id|
    steps = check_distance(unit_id, enemy_id)
    # Choose least amount of steps
    if (steps.length <= best_steps.length || best_steps.empty?) && steps.include?('stuck') == false
      # Make sure we prefer top to bottom, left to right on equally matching steps
      if (steps.length < best_steps.length) || best_steps.empty?
        best_steps = steps.dup
        best_enemy = enemy_id
      elsif (steps.length == best_steps.length) && (@unit_map[best_enemy][:y_axis] > @unit_map[enemy_id][:y_axis])
        best_steps = steps.dup
        best_enemy = enemy_id
      elsif (steps.length == best_steps.length) && (@unit_map[best_enemy][:y_axis] == @unit_map[enemy_id][:y_axis])
        if @unit_map[best_enemy][:x_axis] > @unit_map[enemy_id][:x_axis]
          best_steps = steps.dup
          best_enemy = enemy_id
        end
      end
    puts "The steps for enemy: #{enemy_id}: #{steps}" if @debug
    end
    if steps.include?('stuck')
      if best_steps.empty? || best_steps.nil?
        if (steps.length <= stuck_steps.length || stuck_steps.empty? || stuck_steps.nil?)
          stuck_steps = steps.dup
          stuck_enemy = enemy_id
        end
      end
    end
  end
  if best_enemy.nil?
    best_enemy = stuck_enemy
    best_steps = stuck_steps
  end
  return best_enemy, best_steps
end

def move_unit(unit_id, steps)
  unless steps.include?('stay')
    steps.pop if steps.include?('stuck')
    coords = steps[0].split(',') if (steps.nil? == false && steps.empty? == false)
    @unit_map[unit_id][:y_axis] = coords[0].to_i if coords
    @unit_map[unit_id][:x_axis] = coords[1].to_i if coords
  end
end

def hitting_range(unit_id)
  # Determine closest, first exam hit points for the lowest score and then the order of reading if needed
  possible_enemies = []
  eu = nil
  if @unit_map[unit_id][:unit] == 'E'
    eu = 'G'
  elsif @unit_map[unit_id][:unit] == 'G'
    eu = 'E'
  end
  @unit_map.each do |id, id_details|
    unless id == unit_id
      if (@unit_map[id][:y_axis] == @unit_map[unit_id][:y_axis]) && ((@unit_map[id][:x_axis] - @unit_map[unit_id][:x_axis]).abs == 1) && (id_details[:unit] == eu)
        possible_enemies << id
      elsif (@unit_map[id][:x_axis] == @unit_map[unit_id][:x_axis]) && ((@unit_map[id][:y_axis] - @unit_map[unit_id][:y_axis]).abs == 1) && (id_details[:unit] == eu)
        possible_enemies << id
      end
    end
  end
  puts "Unit id: #{unit_id}: possible enemies: #{possible_enemies}" if @debug
  return false if possible_enemies.empty?
  lowest_hp = 300
  next_possible_enemies = []
  possible_enemies.each do |enemy_id|
    next_possible_enemies = [enemy_id] if @unit_map[enemy_id][:hp] < lowest_hp
    lowest_hp = @unit_map[enemy_id][:hp] if @unit_map[enemy_id][:hp] < lowest_hp
    next_possible_enemies << enemy_id if (@unit_map[enemy_id][:hp] == lowest_hp) && (next_possible_enemies.include?(enemy_id) == false)
  end
  possible_enemies = []
  reading_order_enemy = nil
  if next_possible_enemies.length == 1
    reading_order_enemy = next_possible_enemies[0]
  else
    next_possible_enemies.each do |enemy|
      reading_order_enemy = enemy if reading_order_enemy.nil?
      if reading_order_enemy == enemy
        nil
      elsif @unit_map[reading_order_enemy][:y_axis] > @unit_map[enemy][:y_axis]
        reading_order_enemy = enemy
      elsif @unit_map[reading_order_enemy][:y_axis] == @unit_map[enemy][:y_axis]
        if @unit_map[reading_order_enemy][:x_axis] > @unit_map[enemy][:x_axis]
          reading_order_enemy = enemy
        end
      end
    end
  end
  if reading_order_enemy
    attack(reading_order_enemy)
  end
end

def attack(enemy_id)
  if @unit_map[enemy_id][:hp] - 3 <= 0
    @cave_map[@unit_map[enemy_id][:y_axis]][@unit_map[enemy_id][:x_axis]] = '.'
    @unit_map.delete(enemy_id)
puts "enemy killed: #{enemy_id}"
    fill_in_cavemap
  else
    @unit_map[enemy_id][:hp] = @unit_map[enemy_id][:hp] - 3
  end
end

def enemy_alive(enemy_unit)
  @unit_map.each do |id, unit_details|
    return true if unit_details[:unit] == enemy_unit
  end
  return false
end

def load_map(input_file)
  cave_map_file = File.open(input_file)
  map_point_ctr = 0
  cave_map_file.readlines.each do |axis|
    points = axis.strip.split('')
    points.each_index do |map_point|
      if points[map_point] == 'G'
        @unit_map[map_point_ctr] = { y_axis: @cave_map.length, x_axis: map_point, hp: 200, unit: 'G' }
        points[map_point] = '.'
        map_point_ctr += 1
      elsif points[map_point] == 'E'
        @unit_map[map_point_ctr] = { y_axis: @cave_map.length, x_axis: map_point, hp: 200, unit: 'E' }
        points[map_point] = '.'
        map_point_ctr += 1
      end
    end
    @cave_map << points
  end
end

def print_map
  fill_in_cavemap
  puts "         1         2         3"
  puts "012345679012345678901234567890"
  @cave_map.each_index do |x|
    puts "#{@cave_map[x].join} #{x}"
  end
end

####Main method######
# input_file = 'sample_input1.txt'
# input_file = 'sample_input2.txt'
input_file = 'sample_input3.txt'
load_map(input_file)
fill_in_cavemap


@cave_map.each { |x| puts x.join }
round = 1
enemies_left = true
until enemies_left == false
puts "Round #{round}: is starting============================"
  determine_order.each do |unit_id|
    unless @unit_map[unit_id].nil?
      @unit_map.each do |enemy_id, enemy_details|
        if unit_id == enemy_id
          nil
        else
          point_map(unit_id, enemy_id)
sleep 10
        end
       end
    end
  end
end


####   @cave_map.each { |x| puts x.join }
####   round = 1
####   enemies_left = true
####   until enemies_left == false
####   puts "Round #{round}: is starting============================"
####     determine_order.each do |unit_id|
####       unless @unit_map[unit_id].nil?
####   puts "unit_id turn: #{unit_id}"
####         if @unit_map[unit_id][:unit] == 'E'
####           enemies_left = enemy_alive('G')
####         elsif @unit_map[unit_id][:unit] == 'G'
####           enemies_left = enemy_alive('E')
####         end
####         if enemies_left == true
####           puts "Checking unit: #{unit_id}:  #{@unit_map[unit_id]}" if @debug
####           if hitting_range(unit_id)
####             nil
####           else
####             foe, steps = closest_enemy(unit_id)
####             puts "Closest enemy for #{unit_id}, unit: #{@unit_map[unit_id][:unit]}: is foe: #{foe} with steps: #{steps}" if @debug
####             puts "=====================================" if @debug
####             move_unit(unit_id, steps) if enemy_reachable(foe)
####             fill_in_cavemap
####             hitting_range(unit_id)
####           end
####         end
####       end
####     end
####     print_map
####     determine_order.each do |unit_order|
####       puts "#{unit_order}: #{@unit_map[unit_order]}"
####     end
####     round += 1
####   end
####   
####   puts "Game over, remaining units are:"
####   determine_order.each do |unit_order|
####     puts "#{unit_order}: #{@unit_map[unit_order]}"
####   end
####   puts "Ending round is: #{round -1}"
####   total_hp = 0
####   @unit_map.each do |unit_id, unit_details|
####     total_hp = total_hp + unit_details[:hp]
####   end
####   puts "Total hp is: #{total_hp}"
####   puts "Total score is: #{(round - 1) * total_hp}"
