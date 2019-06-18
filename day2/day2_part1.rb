#!/usr/bin/env ruby

appears_twice = 0
appears_thrice = 0
box_ids = []
boxes = File.open('input_data.txt')
#boxes = File.open('test_data.txt')
boxes.readlines.each do |box|
  box_hash = {}
  box_array = box.strip.split("")
  box_array.each do |letter|
    if box_hash[letter].nil?
      box_hash[letter] = 1 
    else
      box_hash[letter] = box_hash[letter] + 1
    end
  end
  already_seen_twice = false
  already_seen_thrice = false
  box_hash.each do |letter, count|
    if count == 2 && already_seen_twice == false
      appears_twice = appears_twice + 1
      already_seen_twice = true
      box_ids << box
    elsif count == 3 && already_seen_thrice == false
      appears_thrice = appears_thrice + 1
      already_seen_thrice = true
      box_ids << box
    end
  end
end
puts appears_twice * appears_thrice
puts box_ids
