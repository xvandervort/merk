require_relative 'spec_helper'
# how big a tree do I need for decent comparisons.
# I need two and I need to show similar subtrees.
# But I can use shorter codes than 256 bits
# Here's something to try:
# If you assume congruent similarities
# You can simply say one node is included in the list
# at each level until none is found.

describe Merk::TComp do
  include Merk::TComp
  
  context "simple checks" do
    before :each do
      @tree1 = [
        ['aaa'],
        ['bbb', 'ccc'],
        ['ddd', 'eee', 'fff', 'ggg'],
        ['hhh', 'iii', 'jjj', 'kkk', 'lll', 'mmm', 'nnn', 'ooo']
      ]
      
      @tree2 = [
        ['ppp'],
        ['bbb', 'qqq'],
        ['ddd', 'eee', 'rrr', 'sss'],
        ['hhh', 'iii', 'jjj', 'kkk', 'ttt', 'uuu', 'vvv', 'www']
      ]
    end
    
    it "should know identical trees" do
      expect(trees_match?(@tree1, @tree1)).to eq(true)
    end
    
    it "should know different trees" do
      expect(trees_match?(@tree1, @tree2)).to eq(false)
    end
    
    it "should find amount of difference" do
      expect(count_different_nodes(@tree1, @tree2)).to eq(8)
    end
    
    it "should find degree of difference" do
      expect(compute_difference(@tree1, @tree2)).to be_within(0.04).of(0.53) # 0.533333
    end
    
    it "should compute degree of similarity" do
      expect(compute_similarity(@tree1, @tree2)).to be_within(0.007).of(0.466) # 0.4666666
    end
    
    it "should find exact subtree match" do
      expect(find_match(@tree1, @tree2)).to eq([['bbb'], ['ddd', 'eee'], ['hhh', 'iii', 'jjj', 'kkk']])
    end
  end
end