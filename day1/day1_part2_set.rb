#!/usr/bin/env ruby
require 'set'

frequency = 0
frequency_set = Set.new
frequency_set.add(0)
f = true
while f == true do
  frequency_list = File.open('frequencies.txt')
  frequency_list.readlines.each do |freq|
    frequency = frequency + freq.to_f
    if frequency_set.include?(frequency)
      puts frequency
      f = false
      break
    else
      frequency_set.add(frequency)
    end
  end
end
