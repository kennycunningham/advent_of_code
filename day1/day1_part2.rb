#!/usr/bin/env ruby

frequency = 0
frequency_arr = []
frequency_arr << frequency
f = true
while f == true do
  frequency_list = File.open('frequencies.txt')
  frequency_list.readlines.each do |freq|
    frequency = frequency + freq.to_f
    if frequency_arr.include?(frequency)
      puts frequency
      f = false
      break
    else
      frequency_arr << frequency
    end
  end
end
