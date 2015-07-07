require 'digest'

module Merk
  module Hasher
    
    # IN: An array
    # Out a shorter array of hashes
    def hash_all(list)
      d = Digest::SHA256.new
      out = []
      
      while list.length > 0
        one = list.shift
        two = list.shift || one
        d << one
        d << two
        out << d.hexdigest
        d.reset
      end
      
      out
    end
  end
end

