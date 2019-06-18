#!/usr/bin/env ruby

# boxes = File.open('test_data_2.txt')
# boxes = File.open('input_data.txt')
boxes = File.open('box_ids.txt')
array_of_boxes = []
boxes.readlines.each do |box|
  array_of_boxes << box.strip.split("")
end
array_of_boxes.each do |box1|
  array_of_boxes.each do |box2|
    counter = 0
    box1.each_index do |x|
      counter = counter + 1 if box1[x] != box2[x]
    end
    if counter == 1
      box2.delete((box2 - box1)[0])
      puts box2.join("")
    end
  end
end
