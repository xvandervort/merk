require 'json'

module Merk
  class Output
    attr_reader :mode, :file
    MODES = ['text', 'serial', 'json'] 
    
    def initialize(file: nil, mode: MODES.first, pretty_print: false)
      raise(ArgumentError, "Unknown mode #{ mode }") unless MODES.include?(mode)
      @mode = mode
      @file = file
      @pretty = pretty_print
    end
    
    # formats data according to mode
    def fmt(data, pretty: false)
      @pretty = pretty 
      case @mode
      when 'json'
        JSON.generate({tree: data})
        
      when 'serial'
        Marshal.dump data
        
      else
        if @pretty == true
          data.collect{|x| x.to_s}.join("\n")
        else
          data.to_s
        end
      end
    end
    
    # writes to file as needed
    # TODO: Add a png mode where it writes out 
    def write(data)
      out = fmt(data)

      if @file.nil?
        # If there's no file, just use puts
        puts out
        
      else
      
        #raise(ArgumentError, "Unable to open file #{ @file } for writing.") unless File.writable?(@file)
        f1 = File.open(@file, "w")
        f1.puts out
        f1.close
        true
      end
    end
  end
end