module Audiometa
  
  class AudioFile 
    
    attr_reader :extension
    attr_reader :artist
    attr_reader :track
    
    def initialize(file_path)
      @path = file_path
      raise 'File not found or unreadable.' unless File.exists? @path and File.readable? @path
      @extension = File.extname(file_path)
      raise 'Not a valid audio file.' unless @extension == '.mp3'
      
      metadata = parse_metadata
      @artist = metadata['artist']
      @track = metadata['track']
    end
    
    def parse_metadata
      bytes = get_last_bytes(128)
    end
    
    private
    
    def get_last_bytes(n)
      File.open(@path) do |f|
        f.seek(-n, IO::SEEK_END)
        f.read
      end
    end
  
  end
  
end