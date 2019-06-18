#!/usr/bin/env ruby

require 'linked-list'

def store_recipe(recipe)
  @recipe_ten_thousand[(@recipe_count - 1) / 10000] = [] if @recipe_ten_thousand[(@recipe_count - 1) / 10000].nil?
  @recipe_ten_thousand[(@recipe_count - 1) / 10000] << recipe
end

def load_recipe(position)
  # count = @recipe_count / 10000
  count = position / 10000
  # position = position - (10000 * count)
  position_mod = position - (10000 * count)
  # @recipe_ten_thousand[@recipe_count / 10000][position]
  @recipe_ten_thousand[position / 10000][position_mod]
end

def sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos)
#puts "elf_scores 1 and 2: #{elf1_score}, #{elf2_score}"
#puts "elf_pos 1 and 2: #{elf1_pos}, #{elf2_pos}"
#puts "recipe count: #{@recipe_count}"
  sum = elf1_score + elf2_score
  @recipe_count += 1
  store_recipe(sum.to_s[0].to_i)
  if sum.to_s[1]
    @recipe_count += 1
    store_recipe(sum.to_s[1].to_i) if sum.to_s[1]
  end
end

def elfs_pos(elf_score, elf_pos)
  # Add the score + 1 + plus the elf's current array position to
  # figure out the new elf recipe position
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
until @recipe_count >= num_of_recipes
#puts "sum recipe input #{elf1_score}, #{elf2_score}, #{elf1_pos}, #{elf2_pos}"
  sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos)
  elf1_pos = elfs_pos(elf1_score, elf1_pos)
  elf2_pos = elfs_pos(elf2_score, elf2_pos)
  elf1_score = elf_score(elf1_pos)
  elf2_score = elf_score(elf2_pos)
end

until @recipe_count >= (num_of_recipes + 10)
  sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos)
  elf1_pos = elfs_pos(elf1_score, elf1_pos)
  elf2_pos = elfs_pos(elf2_score, elf2_pos)
  elf1_score = elf_score(elf1_pos)
  elf2_score = elf_score(elf2_pos)
end

score_arr = []
10.times do |x|
  score_arr << load_recipe(num_of_recipes + x)
end
puts "Part 1 answer: #{score_arr.join}"


