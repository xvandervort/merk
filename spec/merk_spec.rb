require_relative './spec_helper'

describe Merk do
  include Merk
  it 'has a version number' do
    expect(Merk::VERSION).not_to be nil
  end

  context "working with binary files" do
    before :each do
      @file_name = "sample.png"
      fh = double(File)
      b1 = "a chunk of text with not too many words in it"
      # prevent it from reading a file or even looking for it
      # I know it's a long way to go but it's better than reading a real file
      expect(File).to receive(:open).with(@file_name, "r").and_return(fh)
      expect(fh).to receive(:eof).and_return(false)
      allow(fh).to receive(:read).and_return(b1)
      expect(fh).to receive(:eof).and_return(true)
    end

    it "should make one layer" do
      tree = make_tree_from(@file_name)
      expect(tree).to be_kind_of(Array)
      expect(tree.size).to eq(2)
    end

    it "should know two trees are identical" do
      tree = make_tree_from(@file_name)

      filename2 = "someotherfile.png"
      fh = double(File)
      b1 = "a chunk of text with not too many words in it"
      # prevent it from reading a file or even looking for it
      # I know it's a long way to go but it's better than reading a real file
      expect(File).to receive(:open).with(filename2, "r").and_return(fh)
      expect(fh).to receive(:eof).and_return(false)
      allow(fh).to receive(:read).and_return(b1)
      expect(fh).to receive(:eof).and_return(true)

      # ******************** end set up stuff

      tree2 = make_tree_from(filename2)
      expect(identical?(tree, tree2)).to eq(true)
    end
  end

  context "working with actual files" do
    it "should return stats of non identical trees" do
      root_path = "#{ File.dirname(__FILE__) }/fixtures"
      tree1 = make_tree_from("#{ root_path }/meeting_initiation.png")
      tree2 = make_tree_from("#{ root_path }/amalgam1.png")
      ans = comparison_stats(tree1, tree2)
      expect(ans).to be_kind_of(Hash)
      expect(ans[:match]).to eq(false)
      expect(ans[:similarity]).to be_within(0.01).of(0.81)
    end
  end
end
