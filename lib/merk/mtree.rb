require_relative 'hasher'

class Mtree
  include Merk::Hasher
  attr_reader :raw
  
  def initialize(args = [])
    @raw = args
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
    @tree = []  # this is where the levels of the merk tree will be stored
    layer = @raw

    while layer.size > 1 do
      layer2 = hash_all(layer)

      @tree << layer2.clone
      layer = layer2.clone
    end
    
    @tree
  end
end


# Add an array of data from the start OR
# add one element at a time, or both.
# start with array 