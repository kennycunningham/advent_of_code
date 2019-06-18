#!/usr/bin/env ruby

require 'linked-list'

def sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos, sliding_window, sliding_window_length)
  sum = elf1_score + elf2_score
  recipes_produced = 0
  @recipes << sum.to_s[0].to_i
  sliding_window = sliding_window + sum.to_s[0]
  recipes_produced += 1
  if sum.to_s[1]
    @recipes << sum.to_s[1].to_i if sum.to_s[1]
    sliding_window = sliding_window + sum.to_s[1]
    recipes_produced += 1
  end
  if sliding_window.size > sliding_window_length
    sliding_window = sliding_window[(sliding_window.length - sliding_window_length)..sliding_window.length]
  end
puts "Recipes produced on run: #{@recipes.length}" if @recipes.length % 1000 == 0
  return sliding_window, recipes_produced
end

def elfs_pos(elf_score, elf_pos)
  # Add the score + 1 + plus the elf's current array position to
  # figure out the new elf recipe position
  pos = elf_score + 1 + elf_pos
  if pos > (@recipes.length)
    until pos < (@recipes.length)
     pos = pos - (@recipes.length)
    end
  end
  return pos
end

def elf_score(elf_pos)
  # recipe_list = LinkedList::List.new
  # (@recipes.length - elf_pos).times do |pos|
  #   recipe_list << @recipes.pop
  # end
  # elf_score = @recipes.last
  # until recipe_list.length == 0
  #   @recipes << recipe_list.pop
  # end
  recipe_list = @recipes.dup
  (recipe_list.length - elf_pos).times do |pos|
    recipe_list.pop
  end
  elf_score = recipe_list.last
  return elf_score
end

def find_last_ten_recipes(num_of_recipes)
  recipe_list = LinkedList::List.new
  until @recipes.length == num_of_recipes
    recipe_list << @recipes.pop
  end
  ten_recipes_after = []
  until ten_recipes_after.length == 10
    ten_recipes_after << recipe_list.pop
  end
  return ten_recipes_after.join
end

@recipes = LinkedList::List.new
@recipes << 3
elf1_score = @recipes.last
@recipes << 7
elf2_score = @recipes.last
elf1_pos = 1
elf2_pos = 2
recipes_produced = 0
@recipe_window = ''

sliding_window = '37'
string_match = '360781'
num_of_recipes = 360781
num_of_recipes = 9995
# Make sliding window twice the size in case there are two recipes created
sliding_window_length = string_match.size + 11
until @recipes.length >= num_of_recipes
  sliding_window, recipes_produced = sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos, sliding_window, sliding_window_length)
  elf1_pos = elfs_pos(elf1_score, elf1_pos)
  elf2_pos = elfs_pos(elf2_score, elf2_pos)
  elf1_score = elf_score(elf1_pos)
  elf2_score = elf_score(elf2_pos)
end

recipe_length = @recipes.length
until (recipe_length + 10) <= @recipes.length do
  sliding_window, recipes_produced = sum_recipes(elf1_score, elf2_score, elf1_pos, elf2_pos, sliding_window, sliding_window_length)
  elf1_pos = elfs_pos(elf1_score, elf1_pos)
  elf2_pos = elfs_pos(elf2_score, elf2_pos)
  elf1_score = elf_score(elf1_pos)
  elf2_score = elf_score(elf2_pos)
end

# Pop off the sliding window array until the string_match is off, then grab the first ten and return
puts "The last ten after match is: #{find_last_ten_recipes(num_of_recipes)}"
