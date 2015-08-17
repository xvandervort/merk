# compares 2 merkle trees for similarity.
# returns a score, a subtree of similarities
# or both. Or a true false value
module Merk
  # Tree comparator
  module TComp
    
    # Assumption: A tree is an array of arrays
    # with the root at the top (first.first)
    # getting progressively larger the farther down it goes
    def trees_match?(t1, t2)
      !!(t1.first.first == t2.first.first)
    end
    
    def count_different_nodes(t1, t2)
      a = t1.flatten - t2.flatten
      a.size
    end
    
    def compute_difference(t1, t2)
      amt = count_different_nodes(t1, t2)
      amt.to_f / t1.flatten.size.to_f
    end
    
    def compute_similarity(t1, t2)
      1.0 - compute_difference(t1, t2)
    end
    
    # returns matching subtree
    # of elements from t2 that are also in t1
    def find_match(t1, t2)
      match = []
      # In order to find things that match but in different rows,
      # everything in t2 will be compared to a flattened version of t1
      t = t1.flatten
      t2.each do |row|
        m = row.select{|z| t.include? z}
        match << m unless m.empty?
      end
      
      match
    end
    
    def compare_rows(row1, row2)
      # we need to know the positions of matches, not the exact matching element
      matches = []
      row2.each do |e|
        i = row1.index(e)
        matches << i unless i.nil?
      end
      
      matches
    end
    
    def find_all_matches(t1, t2)
      t1a = if t1.first.size >1
        t1.clone.reverse
      else
        t1.clone
      end
      
      t2a = if t2.first.size >1
        t2.clone.reverse
      else
        t2.clone
      end
    
      # start at the top of one tree and check the other one for everything, working down until you find a match.
      # Then pursue that match all the way down.
      # Then, finish up the remainder in the same way. That's going to be the hard part.
      list = t2a.flatten
      t1a.each do |current_level|
        current_level.each do |node|
          if list.include?(node)
            #subtrees << get_subtree(from here down ...)
            # from any given node, there is only one possible subtree.
            # so that must be sent for comparison
            # How do I define a subtree?
            # form a node, it is the two children and their children, all the way down.
            #But there's no explicit indexing of children. So, how do we find them?
          end
        end 
      end
    end
  end
end
