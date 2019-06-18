#!/usr/bin/env ruby

require 'linked-list'

def store_recipe(recipe)
  @recipe_ten_thousand[(@recipe_count - 1) / 10000] = [] if @recipe_ten_thousand[(@recipe_count - 1) / 10000].nil?
  @recipe_ten_thousand[(@recipe_count - 1) / 10000] << recipe
end

def load_recipe(position)
  count = position / 10000
  position_mod = position - (10000 * count)
  @recipe_ten_thousand[position / 10000][position_mod]
end

def sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos, recipe_reached, match_string, sequence)
  sum = elf1_score + elf2_score
  @recipe_count += 1
  store_recipe(sum.to_s[0].to_i)
  match_string << sum.to_s[0].to_i
  match_string.shift if match_string.length > sequence.size
  return true, match_string if match_string.join.include?(sequence.to_s)
  if sum.to_s[1]
    @recipe_count += 1
    store_recipe(sum.to_s[1].to_i) if sum.to_s[1]
    match_string << sum.to_s[0].to_i
    match_string.shift if match_string.length > sequence.size
    return true, match_string if match_string.join.include?(sequence.to_s)
  end
  return false, match_string
end

def elfs_pos(elf_score, elf_pos)
  pos = elf_score + 1 + elf_pos
  if pos > (@recipe_count - 1)
    until pos < (@recipe_count)
     pos = pos - (@recipe_count)
    end
  end
  return pos
end

def elf_score(elf_pos)
  return load_recipe(elf_pos)
end


@recipe_ten_thousand = {}
@recipe_ten_thousand[0] = []
@recipe_count = 2
@recipe_ten_thousand[0] << 3
elf1_score = 3
@recipe_ten_thousand[0] << 7
elf2_score = 7
elf1_pos = 0
elf2_pos = 1

num_of_recipes = 360781
stop_run = false
match_string = []
until stop_run == true
  stop_run, match_string = sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos, recipe_reached = false, match_string, num_of_recipes.to_s)
  elf1_pos = elfs_pos(elf1_score, elf1_pos)
  elf2_pos = elfs_pos(elf2_score, elf2_pos)
  elf1_score = elf_score(elf1_pos)
  elf2_score = elf_score(elf2_pos)
end

score_arr = []
10.times do |x|
  score_arr << load_recipe(@recipe_count - num_of_recipes.size + 1 - x)
end
puts "Part 2 10 before number: #{score_arr.reverse.join}"
puts "Part 2 count: #{@recipe_count - 6}"
