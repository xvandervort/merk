require_relative 'hasher'

class Mtree
  include Merk::Hasher
  attr_reader :raw, :tree

  def initialize(args = [])
    @raw = args
    @tree = []

    make_tree unless @raw.empty?
  end

  def <<(arg)
    if arg.is_a?(Array)
      @raw.concat arg

    else
      @raw << arg
    end
  end

  # IN: a file handle and chunk size
  # Assumption: The file handle is open
  # and will be closed after we're done here.
  def ingest(fh, chunk_size = 1024)
    while !fh.eof do
      @raw << fh.read(chunk_size)
    end
  end

  # assumes raw is filled and
  # builds a merkle tree from the bottom to the top
  def make_tree
      # this is where the levels of the merk tree will be stored
    layer = @raw.clone
    size = 99
    d = Digest::SHA256.new
    @tree = []
    @tree << @raw.collect do |r|
      d.reset
      d << r.to_s
      d.hexdigest
    end

    while size > 1
      layer2 = hash_all(layer)

      @tree << layer2.clone
      layer = layer2.clone
      size = layer.size
    end

    # but doing this gives you the raw data at the top and the single-node apex at the bottom
    # this is confusing so the tree needs to be flipped upside down.
    @tree.reverse!
  end

  # quick and dirty print to console
  def pp
    @tree.each do |l|
      puts l.join(", ")
    end

    true
  end

  def find_element(unk)
    x = -1
    y = nil
    while y.nil? && x < @tree.size
      x += 1
      y = @tree[x].index(unk)
    end

    [x, y]  # @tree[x][y] = coordinates of the given element
  end

  # extract contiguous subelements from a tree starting from the apex and working down
  # and return results as a tree. Hmmm. That means just find the bottom and allow it to build itself up.
  # IF and only if the tree is correctly formed.
  def subtree(top)
    # first, find the given element in the tree
    x, y = find_element top
    new_tree = Mtree.new
    new_tree.tree << [@tree[x][y]]
    num_elements = 1

    unless y.nil?
      # extract the elements below into a new tree.
      #every level below should have twice as many elements as the current,
      # Also, there is a leftward bias. This gives you a starting point.
      # if the current element is at position 4
      # that means it was derived fro mthose with y = y + 1 and x * 2 -1 and x * 2.
      # Unless there is nothing at x * 2 in which case, leave it empty.
      until x == @tree.size - 1
        x += 1  # Because the tree is inverted!
        puts " "
        num_elements *= 2
        y *= 2

        #puts "x = #{ x}; y = #{ y}; number of elements to pull = #{ num_elements}"
        new_tree.tree << @tree[x][y, num_elements]
      end
    end

    new_tree
  end
end
