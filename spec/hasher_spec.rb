require_relative 'spec_helper'
require 'digest'

describe Merk::Hasher do
  include Merk::Hasher
  
  context "making hashes" do
    before :each do
      @list = [ 'one', 'two', 'three' ]
    end
    
    it "should hash pairs" do
      d = Digest::SHA256.new
      d << @list[0]
      d << @list[1]
      
      correct = [d.hexdigest]
      d.reset
      d << @list[2]
      d << @list[2]  #double up on the last one when odd length list
      correct << d.hexdigest
      # end setup
      
      expect(hash_all(@list)).to eq(correct)
    end
  end
end
