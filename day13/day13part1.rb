#!/usr/bin/env ruby

require 'pp'

# @input_file = 'small_input.txt'
# @input_file = 'another_input.txt'
# @input_file = 'cb_input.txt'
# @input_file = 'input-repaste.txt'
@input_file = 'input.txt'

# Make sure we pick cars in order of top to bottom and left to right
def check_order
  car_order = []
  @car_hash.each { |car, car_details| car_order << car }
  swap = true
  while swap
    swap = false
    (car_order.length - 1).times do |x|
      if @car_hash[car_order[x]][:coord_y] > @car_hash[car_order[x + 1]][:coord_y]
        car_order[x], car_order[x+1] = car_order[x+1], car_order[x]
        swap = true
      elsif @car_hash[car_order[x]][:coord_y] == @car_hash[car_order[x + 1]][:coord_y]
        if @car_hash[car_order[x]][:coord_x] > @car_hash[car_order[x + 1]][:coord_x]
          car_order[x], car_order[x+1] = car_order[x+1], car_order[x]
          swap = true
        end
      end
    end
  end
  puts "Car order below:"
  car_order.each { |car| puts "car #{car}: #{@car_hash[car][:coord_x]},#{@car_hash[car][:coord_y]}" }
  return car_order
end

# Set the direction and the next turn to make
def check_next_point(direction, coord_x, coord_y, next_dir)
  if @track_array[coord_x][coord_y] == '-'
    direction = direction
  elsif @track_array[coord_x][coord_y] == '|'
    direction = direction
  elsif @track_array[coord_x][coord_y] == '/' && direction == '<'
    direction = 'v'
  elsif @track_array[coord_x][coord_y] == '/' && direction == '^'
    direction = '>'
  elsif @track_array[coord_x][coord_y] == '/' && direction == '>'
    direction = '^'
  elsif @track_array[coord_x][coord_y] == '/' && direction == 'v'
    direction = '<'
  elsif @track_array[coord_x][coord_y] == "\\" && direction == '<'
    direction = '^'
  elsif @track_array[coord_x][coord_y] == "\\" && direction == 'v'
    direction = '>'
  elsif @track_array[coord_x][coord_y] == "\\" && direction == '>'
    direction = 'v'
  elsif @track_array[coord_x][coord_y] == "\\" && direction == '^'
    direction = '<'
  elsif @track_array[coord_x][coord_y] == '+'
    if next_dir == 'left'
      next_dir = 'straight'
      if direction == '<'
        direction = 'v'
      elsif direction == 'v'
        direction = '>'
      elsif direction == '>'
        direction = '^'
      elsif direction == '^'
        direction = '<'
      end
    elsif next_dir == 'straight'
      next_dir = 'right'
    elsif next_dir == 'right'
      next_dir = 'left'
      if direction == '<'
        direction = '^'
      elsif direction == 'v'
        direction = '<'
      elsif direction == '>'
        direction = 'v'
      elsif direction == '^'
        direction = '>'
      end
    end
  end
  return { direction: direction, coord_x: coord_x, coord_y: coord_y, next_dir: next_dir, current_symbol:  @track_array[coord_x][coord_y] }
end

# Determine the next position to be put in
def next_move(cart)
 puts "======================"
 puts "Cart before: #{cart}"
  if cart[:direction] == '<'
    cart = check_next_point(cart[:direction], (cart[:coord_x] - 1), cart[:coord_y], cart[:next_dir])
  elsif cart[:direction] == '>'
    cart = check_next_point(cart[:direction], (cart[:coord_x] + 1), cart[:coord_y], cart[:next_dir])
  elsif cart[:direction] == 'v'
    cart = check_next_point(cart[:direction], cart[:coord_x], (cart[:coord_y] + 1), cart[:next_dir])
  elsif cart[:direction] == '^'
    cart = check_next_point(cart[:direction], cart[:coord_x], (cart[:coord_y] - 1), cart[:next_dir])
  end
 puts "Cart after: #{cart}"
  return cart
end

# Detect crash, checking if the array has the coords, we know there is a crash if another car matches the coords
def check_for_crash
  coords = []
  @car_hash.each do |car, car_details|
puts "car: #{car}: #{car_details[:coord_x]},#{car_details[:coord_y]}"
    if coords.include?("#{car_details[:coord_x]},#{car_details[:coord_y]}")
      return "#{car_details[:coord_x]},#{car_details[:coord_y]}"
    else
      coords << "#{car_details[:coord_x]},#{car_details[:coord_y]}"
    end
  end
  return false
end

# Display graph where the direction is listed
def graph_track
  y_axis = []
  track_file = File.open(@input_file)
  track_file.readlines.each do |x|
    y = x.split("")
    y.each_index do |point|
      y[point] = '-' if y[point] == '<' || y[point] == '>'
      y[point] = '|' if y[point] == '^' || y[point] == 'v'
    end
    y_axis << y
  end
  @car_hash.each do |car, car_details|
    x = car_details[:coord_x]
    y = car_details[:coord_y]
    direction = car_details[:direction]
    y_axis[y][x] = direction
  end
  column_top = 0
  column_str1 = "#{column_top}         "
  column_str2 = '0123456789'
  14.times {|column| column_str1 = "#{column_str1}" + "#{column + 1}         " }
  14.times {|column| column_str2 = "#{column_str2}" + '0123456789' }
  puts column_str1
  puts column_str2
  y_axis.each_index do |x|
    if %w(< v > ^).any? { |dir| y_axis[x].include?(dir) }
      puts y_axis[x].join
    end
  end
end

# Loading track time
track_file = File.open(@input_file)
row_length = 0
column_length = 1
track_file.readlines.each do |x|
  row_length = x.length
  column_length = column_length += 1
end
@track_array = Array.new(row_length) { Array.new(column_length) }

# Load map and cars into the appropriate arrays and hashes
@car_hash = {}
i = 0
track_file = File.open(@input_file)
track_file.readlines.each do |x|
  j = 0
  x.split("").each do |y|
    if y == '<' || y == '>'  
      @track_array[j][i] = '-'
      @car_hash["#{j}#{i}"] = { direction: y, coord_x: j, coord_y: i, next_dir: 'left', current_symbol: '-' }
    elsif y == '^' || y == 'v'  
      @track_array[j][i] = '|'
      @car_hash["#{j}#{i}"] = { direction: y, coord_x: j, coord_y: i,  next_dir: 'left', current_symbol: '|' }
    else
      @track_array[j][i] = y
    end
    j += 1
  end
  i += 1
end

graph_track
crash = false
# Continue looping till a crash occurs
while crash == false
  co = check_order
  co.each do |cart|
    @car_hash[cart] = next_move(@car_hash[cart])
    crash = check_for_crash
    break if crash
  end
  graph_track
end

puts "I crashed here: #{crash}"
