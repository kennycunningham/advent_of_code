#!/usr/bin/env ruby

@nodes_map = {}
@sum_of_values = 0

def sum_up_values(position)
  if @sections[position] == 0
    value = 0
    num_of_pos_delete = 2 + @sections[position + 1]
    @sections[position + 1].times do |times|
      value = value + @sections[(position + 2 + times)]
      @sum_of_values = @sum_of_values + @sections[(position + 2 + times)]
    end
    @nodes_map[position] = { value: value, nodes: [] }
    @sections[position - 2] = (@sections[position - 2] - 1)
    num_of_pos_delete.times { |del_elem| @sections.delete_at(position) }
  elsif @sections[position] != 0
    sum_up_values(position + 2)
  end
end

nodes_file = File.open('small_input.txt')
# nodes_file = File.open('input.txt')
sections = []
nodes_file.readlines.each do |nodes_meta|
  @sections = nodes_meta.split(' ').map(&:to_i)
end

until @sections.empty?
  sum_up_values(0)
end

puts "Part 1 answer: #{@sum_of_values}"

puts @nodes_map.to_s
