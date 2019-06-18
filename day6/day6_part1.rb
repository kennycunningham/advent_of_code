#!/usr/bin/env ruby

plot_number = 0
plot_points = []

plot_input = File.open('small_input.txt')
plot_input.readlines.each do |plot|
  plots = plot.gsub(/ /,'').chomp.split(',')
  plots[0] = plots[0].to_i
  plots[1] = plots[1].to_i
  plot_points << plots
end







total_dist = {}
total_plots = 0
map_of_points
plot_points.each do |point1|
  plot_points.each do |point2|
    l1 = ((point1[0] - point2[0]))/2).abs
    l2 = ((point1[1] - point2[1]).abs)/2).abs
    a = 
    map_of_points[total_plots] = [
  end
   
  total_plots += 1
end





most_distance = 0
plot_number_high = 0
puts total_dist
total_dist.each do |plot_number, distance|
  if distance > most_distance
    most_distance = distance
    plot_number_high = plot_number
  end
end
puts "plot_number with most coverage: #{plot_number_high} at #{most_distance}"
