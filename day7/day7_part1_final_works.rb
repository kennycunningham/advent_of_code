#!/usr/bin/env ruby

@steps = {}
@order = []
@all_keys = {}
@placement = []

# Checks if deps are met and returned true
def check_for_deps(letter)
  return true if @steps[letter].empty?
  prereq_size = 0
  @steps[letter].each do |prereq|
    prereq_size += 1 if @placement.include?(prereq)
  end
  return true if prereq_size == (@steps[letter].size)
end

#instructions = File.open('small_input.txt')
instructions = File.open('input.txt')
instructions.readlines.each do |instruction|
  sections  = instruction.split(' ')
  prereq = sections[1]
  step = sections[7]
  @steps[step] = [] if @steps[step].nil?
  @steps[step] = @steps[step] << prereq
  @steps[step] = @steps[step].sort
end

# Load all keys that lack dependencies
tmp_steps = {}
@steps.each do |key, prereq|
  prereq.each do |letter|
    tmp_steps[letter] = [] if @steps[letter].nil?
  end
end
@steps = @steps.merge(tmp_steps)

resort_keys = {}
@steps.keys.sort.each do |letter|
  resort_keys[letter] = @steps[letter]
end
@steps = resort_keys

until @placement.size == @steps.size
  @steps.each do |key, _|
    if check_for_deps(key) && @placement.include?(key) == false
      @placement << key
      break
    end
  end
end

puts @placement.join
