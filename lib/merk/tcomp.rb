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
  end
end