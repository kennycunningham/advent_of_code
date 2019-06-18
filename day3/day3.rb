#!/usr/bin/env ruby

require 'set'
# user set to add map hits into it, then can figure whole square inches used by total

fabric_req = File.open('input.txt')
test_sets = Set.new
dup_set = Set.new
users_set = Set.new
users_hash = {}
fabric_req.readlines.each do |req|
  fab_sect = req.split(" ")
  user = fab_sect[0].gsub(/#/,'')
  lstart = fab_sect[2].split(',')[0].to_i
  tstart = fab_sect[2].split(',')[1].gsub(/:/,'').to_i
  width = fab_sect[3].split('x')[0].to_i
  height = fab_sect[3].split('x')[1].to_i
  lend = lstart + width
  hend = tstart + height
  user_point = Set.new
  for i in lstart...lend do
    for j in tstart...hend do
      if test_sets.include?("#{i},#{j}")
        dup_set.add("#{i},#{j}")
      end
      user_point.add("#{i},#{j}")
      test_sets.add("#{i},#{j}")
    end
  end
  users_hash[user] = user_point
end

users_hash.each do |user1, point1|
  users_set.add(user1) if dup_set.disjoint? point1
end

puts "Inches overlap: #{dup_set.size}"
puts "No dup user: #{users_set.inspect}"
