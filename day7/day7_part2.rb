#!/usr/bin/env ruby

@steps = {}
@order = []
@all_keys = {}
@placement = []
@time_to_take_per_step = 0
@num_of_workers = 2
@alpha_map = ('A'..'Z').to_a
@levels_hash = {}
@placement2 = []
@iteration_for_deps = 0

# Checks if deps are met and returned true
def check_for_deps(letter)
  if @steps[letter].empty?
    return true if @steps[letter].empty?
  end
  prereq_size = 0
  @steps[letter].each do |prereq|
    prereq_size += 1 if @placement.include?(prereq)
  end
  if prereq_size == (@steps[letter].size)
    return true
  end
end

# Checks if deps are met and returned true
def check_for_deps2(letter)
  if @steps[letter].empty?
    return true if @steps[letter].empty?
  end
  prereq_size = 0
  @steps[letter].each do |prereq|
    prereq_size += 1 if @placement2.include?(prereq)
  end
  if prereq_size == (@steps[letter].size)
    return true
  end
end

instructions = File.open('small_input.txt')
# instructions = File.open('input.txt')
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

until @placement2.size == @steps.size
  load_key = []
  @steps.each do |key, _|
    if check_for_deps2(key) && @placement2.include?(key) == false
      @levels_hash[@iteration_for_deps] = [] if @levels_hash[@iteration_for_deps].nil?
      @levels_hash[@iteration_for_deps] << key
      load_key << key
    end 
  end
  load_key.each {|letter| @placement2 << letter }
  @iteration_for_deps += 1
end

puts "Part 1 answer: #{@placement.join}"


current_time = 0
# Keep track of workers and the current_time before they become available
@workers = {}
@num_of_workers.times do |worker|
  @workers[worker] = { finish_time: 0, current_letter: nil}
end

puts "Current levels: #{@levels_hash.to_s}"
puts "Number of workers: #{@workers}"
# Now go through the levels and figure the time it takes for the steps
@levels_hash.each do |level, letters|
  last_finish_on_level = 0
  letters.each do |letter|
    letter_assigned = false
    until letter_assigned == true 
      @workers.each do |worker, worker_info|
        if @workers[worker][:finish_time] <= current_time && letter_assigned == false
          # Make sure we make the time consecutive
          # Add the finish time
          finish_time = @time_to_take_per_step + @alpha_map.index(letter)  + 1 + worker_info[:finish_time]
          @workers[worker] = {finish_time: finish_time, current_letter: letter}
puts "Worker #{worker}: #{@workers[worker]}: Current time: #{current_time}"
          letter_assigned = true
puts "last finish time: #{last_finish_on_level}" if finish_time >= last_finish_on_level
          last_finish_on_level = finish_time if finish_time >= last_finish_on_level
        end
      end
    end
  end
  current_time += 1 until last_finish_on_level == current_time
end

puts "Time to take steps: #{current_time}"
