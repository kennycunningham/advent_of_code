class CircularList
  include Enumerable
  attr_accessor :head

  # -------------------------------
  # Deletion operation.
  # -------------------------------
  def delete(doomed)
    # If there is no head, or if there is only
    # one node in the list, then point the head of
    # the list to nil.
    @head = nil if single_node_list?
    return if headless?

    # 'Remove' the doomed node by shifting the
    # contents of its successor into itself.
    successor = doomed.next_node
    adopt_successor(doomed, successor)
  end

  # -------------------------------
  # Utility methods for deletion.
  # -------------------------------
  def adopt_successor(doomed, successor)
    doomed.data = successor.data
    doomed.next_node = successor.next_node

    # If the sucessor to the doomed node is
    # the @head, then the @head must be
    # reassigned to point to the doomed node,
    # which has now been populated with the
    # content of its successor.
    @head = doomed if successor == @head
  end

  def headless?
    !@head
  end

  def single_node_list?
    # If the next_node of the @head node in the
    # circular linked-list is identical to the
    # @head, then the node at the head of the list
    # is pointing to itself. Thus, it is a single
    # node list.
    @head == @head.next_node
  end

  # -------------------------------
  # Previously detailed methods.
  # -------------------------------
  def insert(data)
    new_node = Node.new(data)

    if !@head
      new_node.next_node = new_node
      @head = new_node

    else
      new_node.next_node = @head.next_node
      @head.next_node = new_node
      @head.data, new_node.data = new_node.data, @head.data
    end
  end

  def search(data)
    return find do |node|
      node.data == data
    end
  end

  def each
    node = @head
    while node 
      yield node
      node = node.next_node
      break if node == @head
    end
  end
end

class Node
  attr_accessor :data, :next_node

  def initialize(data, next_node = nil)
    @data = data
    @next_node = next_node
  end
end
