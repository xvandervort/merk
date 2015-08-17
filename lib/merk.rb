require_relative "merk/version"
require_relative "merk/mtree"
require_relative 'merk/hasher'
require_relative "merk/tcomp"
require_relative 'merk/output'

module Merk
  include TComp
  
  # given a file name, method ingests the file
  # and builds a tree from it
  # assumption: file has been checked for readability
  def make_tree_from(filename)
    @m = Mtree.new
    # TODO: Implement text file ingestion
    fh = File.open(filename, "r")
    @m.ingest fh
    @m.make_tree 
  end
  
  # compares the merkle root of 2 trees.
  # returns true if they are the same, false if not
  def identical?(t1, t2)
    trees_match? t1, t2
  end
  
  # assumption: each tree is in the form of an array with nested arrays (1 per level)
  def comparison_stats(tree1, tree2)
    out = {}
    out[:match] = trees_match?(tree1, tree2)
    out[:similarity] = compute_similarity(tree1, tree2)
     
    out
  end
end
