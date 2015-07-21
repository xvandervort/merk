require_relative 'spec_helper'

describe Merk::Output do
  context "init" do
    it "should use default mode" do
      o = Merk::Output.new
      expect(o.mode).to eq('text')
    end
    
    it "should use mode given" do
      m = 'serial'
      o = Merk::Output.new mode: m
      expect(o.mode).to eq(m)
    end
    
    it "should reject unknown mode" do
      expect{ Merk::Output.new(mode: 'fancy') }.to raise_error(ArgumentError)
    end
    
    it "should accept mode json" do
      m = "json"
      o = Merk::Output.new mode: m
      expect(o.mode).to eq(m)
    end
    
    it "should accept file param" do
      f = "somefile.txt"
      o = Merk::Output.new file: f
      expect(o.file).to eq(f)
    end
    
    pending "should accept locations param"  # possible locations being file, socket, image and db?
    # because without this it either goes to file or not a file
  end
  
  context "formatting" do
    before :each do
      @data = [['one'], ['two', 'three']]
      
    end
    
    it "should return plain text" do
      o = Merk::Output.new mode: 'text'
      expect(o.fmt(@data)).to eq(@data.to_s)
    end
    
    it "should return json" do
      o = Merk::Output.new mode: 'json'
      expect(o.fmt(@data)).to eq("[[\"one\"],[\"two\",\"three\"]]")
    end
    
    it "should serialize" do
      o = Merk::Output.new mode: 'serial'
      expect(o.fmt(@data)).to eq("\x04\b[\a[\x06I\"\bone\x06:\x06ET[\aI\"\btwo\x06;\x00TI\"\nthree\x06;\x00T")
    end
    
    it "should print trees as nice rows" do
      o = Merk::Output.new 
      expect(o.fmt(@data, pretty: true)).to eq("#{ @data.first.to_s }\n#{@data.last.to_s }")
    end
  end
end