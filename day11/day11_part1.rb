#!/usr/bin/env ruby

require 'pp'

def calculate_grid(serial_number, x_axis, y_axis)
  rack_id = x_axis + 10
  power_level = rack_id * y_axis
  increase_power = power_level + serial_number
  power_rack = increase_power * rack_id
  power_rack_str = power_rack.to_s
  hundreds_pos = power_rack_str[power_rack_str.length - 3].to_i
  power_result = hundreds_pos - 5
#  if x_axis == 122 && y_axis == 79
#    puts rack_id
#    puts power_level
#    puts increase_power
#    puts power_rack
#    puts hundreds_pos
#    puts power_result
#  end
  return power_result
end

@fuel_cell_arr = Array.new(300) { Array.new(300)}

serial_number = 9110

@fuel_cell_arr.each_index do |x_axis|
  @fuel_cell_arr[x_axis].each_index do |y_axis|
    @fuel_cell_arr[x_axis][y_axis] = calculate_grid(serial_number, (x_axis.to_i + 1), (y_axis.to_i + 1))
  end
end

top_x = 0
top_y = 0
total_points = 0

for i in 0..297 do
  for j in 0..297 do
    points = 0
    for a in 0..2 do
      for b in 0..2 do
        points = points + @fuel_cell_arr[i + a][j + b]
      end
    end
    if points > total_points
      total_points = points
      top_x = i
      top_y = j
    end
  end
end

puts "Puts grid start point: #{top_x + 1},#{top_y + 1}"
puts "Total points: #{total_points}"
