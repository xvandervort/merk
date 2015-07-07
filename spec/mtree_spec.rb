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
  end
  
  context "piecmeal array building" do
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
  end
  
  context "tree" do
    it "builds full tree" do
      list = ["one", "two", "three"]
      level_two = make_tree_the_hard_way list
      top = make_tree_the_hard_way level_two

      m = Mtree.new list
      expect(m.make_tree).to eq([level_two, top])
    end
    
    pending "should validate tree as correct"
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