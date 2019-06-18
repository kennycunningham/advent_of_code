#!/usr/bin/env ruby

require 'pp'

# coordinates_file = File.open('small_input.txt')
coordinates_file = File.open('input.txt')
cv_arr = []
coordinates_file.readlines.each do |coord_vel|
  co_vel = coord_vel.split('=')
  pos_x = co_vel[1].split('<')[1].split(',')[0].strip.to_i
  pos_y = co_vel[1].split(',')[1].split('>')[0].strip.to_i
  vel_x = co_vel[2].split('<')[1].split(',')[0].strip.to_i
  vel_y = co_vel[2].split(',')[1].split('>')[0].strip.to_i
  cv_arr << [pos_x, pos_y, vel_x, vel_y]
end


1000000.times do |seconds|
  # Find the data plot size
  @negative_x = 0
  @positive_x = 0
  @negative_y = 0
  @positive_y = 0
  @width = 0
  @height = 0
  height = []
  width = []

  # Increase the seconds and plot points
  cv_arr.each do |co_vel|
    down = (@height / 2) + co_vel[1]
    right = (@width / 2)  + co_vel[0]
    unless seconds == 0
      vel_x = co_vel[2] * seconds
      vel_y = co_vel[3] * seconds
      down = (@height / 2) + co_vel[1] + vel_y
      right = (@width / 2)  + co_vel[0] + vel_x
    end
    height << down
    width << right
  end

  # Figure out plot map size and plot points
  width_height = []
  width_height_arr = []
  height.each_index do |point|
    width_height << "#{width[point]}, #{height[point]}"
    width_height_arr << [width[point], height[point]]
  end
  width_height =  width_height.sort
  width_height_arr =  width_height_arr.sort
  width_height_arr.each do |point|
    @negative_x = point[0] + 30 if point[0] < @negative_x.to_f
    @positive_x = point[0] + 30 if point[0] > @positive_x.to_f
    @negative_y = point[0] + 30 if point[0] < @negative_y.to_f
    @positive_y = point[0] + 30 if point[0] > @positive_y.to_f
    @width = (@negative_x.abs + @positive_x)
    @height = (@negative_y.abs + @positive_y )
  end

  if width_height_arr[0][0] == width_height_arr[1][0] || width_height_arr[0][1] == width_height_arr[1][1]
    puts "Seconds is: #{seconds}"
    @height.times do |height|
      x_string = ''
      @width.times do |width|
        if width_height.include?("#{width}, #{height}") == false
          x_string << ' '
        else
          x_string << '#'
        end
      end
      puts x_string if x_string.include?('#')
    end
  end
end
