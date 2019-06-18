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
