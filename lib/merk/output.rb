require 'json'

module Merk
  class Output
    attr_reader :mode, :file
    MODES = ['text', 'serial', 'json'] 
    
    def initialize(mode: MODES.first, file: nil)
      raise(ArgumentError, "Unknown mode #{ mode }") unless MODES.include?(mode)
      @mode = mode
      @file = file
    end
    
    # formats data according to mode
    def fmt(data)
      case @mode
      when 'json'
        JSON.generate(data)
        
      when 'serial'
        Marshal.dump data
        
      else
        data.to_s
      end
    end
  end
  
  # writes to file as needed
  # TODO: Add a png mode where it writes out 
  def write(data)
    if @file.nil? || @mode == 'none'
      false
      
    else
    
      raise(ArgumentError, "Unable to open file #{ @file } for writing.") unless File.writable_real?(@file)
      out = fmt(data)
      f1 = File.open(@file, "w")
      f1.puts out
      f1.close
      true
    end
  end
end