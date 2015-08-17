require_relative 'spec_helper'
require 'digest'

describe Mtree do
  context "init" do
    it "should create empty raw array" do
      m = Mtree.new
      expect(m.raw).to be_kind_of(Array)
      expect(m.raw.size).to eq(0)
    end
    
    it "should add passed values to raw" do
      m = Mtree.new [1, 2]
      expect(m.raw).to eq([1,2])
    end
    
    it "should automatically build tree when supplied raw input" do
      m = Mtree.new [1, 2, 3, 4]
      expect(m.tree.size).to eq(2)
    end
  end
  
  context "piecmeal building" do
    it "should add new values to raw" do
      m = Mtree.new
      m << 1
      expect(m.raw).to eq([1])
    end
    
    it "should add multiple values to raw" do
      m = Mtree.new
      m << [1,2]
      expect(m.raw).to eq([1,2])
    end
    
    it "should read in a binary file" do
      m = Mtree.new
      f = File.open "#{ File.dirname(__FILE__) }/test_files/first_birthday.png"
      m.ingest f
      expect(m.raw.size).to eq(7940)
    end
    
    it "should insert rows into a tree one at a time" do
      r1 = ['aaa', 'bbb']
      r2 = ['eee']
      
      m = Mtree.new
      m.tree << r1
      m.tree << r2
      expect(m.tree).to eq([r1, r2])
    end
  end
  
  context "tree ops" do
    it "builds full tree" do
      list = ["one", "two", "three"]
      level_two = make_tree_the_hard_way list
      top = make_tree_the_hard_way level_two

      m = Mtree.new list
      expect(m.tree).to eq([top, level_two])
    end
    
    it "retrieves a subtree given top node value" do
      m = Mtree.new ['aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff']
      m.make_tree
      #m.pp
      result = [['a70145e430c9ffc0527e6679bd3d14c3819921c7bdcee060e3e848c1e60fe771'],
                ['2ce109e9d0faf820b2434e166297934e6177b65ab9951dbc3e204cad4689b39c', 'fcb0de60e5febc4dea96c4dc0153362d289f1aa5bd0797db2dcd7f23708205bb']]
      m2 = m.subtree('a70145e430c9ffc0527e6679bd3d14c3819921c7bdcee060e3e848c1e60fe771')
      expect(m2).to be_kind_of(Mtree)
      expect(m2.tree).to eq(result)
    end
    
    it "should find element in tree" do
      m = Mtree.new ['aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff']
      top_node = 'a70145e430c9ffc0527e6679bd3d14c3819921c7bdcee060e3e848c1e60fe771'
      
      x, y = m.find_element top_node
      expect(x).to eq(1)
      expect(y).to eq(0)
      expect(m.tree[x][y]).to eq(top_node)
    end
   
    it "should validate tree as correct"
    it "should freeze tree (make immutable) on command"
    it "should freeze tree automatically after building from raw"
  end
  
  private
  
  def make_tree_the_hard_way(from_this)
    d = Digest::SHA256.new
    out = []
    n = 0
    while n < from_this.size do
      right = from_this[n+1].nil? ? from_this[n] : from_this[n+1]
      d << from_this[n].to_s
      d << right.to_s
      out << d.to_s
      d.reset
      n += 2
    end
    
    out
  end
end