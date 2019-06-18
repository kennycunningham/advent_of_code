#!/usr/bin/env ruby

require 'time'

polymer_string = ''

polymer_input = File.open('input.txt')
polymer_input.readlines.each do |polymer|
  polymer_string =  polymer
end
polymer_split = polymer_string.scan /\w/

still_deleting = true
index_point = 0
while still_deleting do
  still_deleting = false if index_point == (polymer_split.length - 1)
  while index_point < (polymer_split.length - 1)
    if polymer_split[index_point].swapcase == polymer_split[index_point + 1] 
      polymer_split.delete_at(index_point + 1)
      polymer_split.delete_at(index_point)
      if index_point > 2
         index_point = index_point - 2
      else
        index_point = 0
      end
    else
      index_point = index_point + 1
    end  
  end
end
puts "length of polymer: #{polymer_split.size}"

polymer_sizes = {}
polymer_samples = polymer_split.uniq
polymer_samples.each do |polymer|
  polymer_split_mod = polymer_split.dup
  polymer_split_mod.delete(polymer)
  polymer_split_mod.delete(polymer.swapcase)
  still_deleting = true
  index_point = 0
  while still_deleting do
    still_deleting = false if index_point == (polymer_split_mod.length - 1)
    while index_point < (polymer_split_mod.length - 1)
      if polymer_split_mod[index_point].swapcase == polymer_split_mod[index_point + 1]
        polymer_split_mod.delete_at(index_point + 1)
        polymer_split_mod.delete_at(index_point)
        if index_point > 2
           index_point = index_point - 2
        else
          index_point = 0
        end
      else
        index_point = index_point + 1
      end
    end
  end
  polymer_sizes[polymer] = polymer_split_mod.size
end

polymer_lowest = nil
polymer_used = ''
polymer_sizes.each do |polymer, size|
  if polymer_lowest.nil?
    polymer_lowest = size
    polymer_used = polymer
  end
  if polymer_lowest > size
    polymer_lowest = size
    polymer_used = polymer
  end
end
puts "Polymer: #{polymer_used}, size of polymer: #{polymer_lowest}"
