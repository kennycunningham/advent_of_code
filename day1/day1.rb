#!/usr/bin/env ruby

frequency = 0
frequency_list = File.open('frequencies.txt')
frequency_list.readlines.each do |freq|
  frequency = frequency + freq.to_f
end
puts frequency
