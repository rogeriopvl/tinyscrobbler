module Audiometa
  
  class AudioFile 
    
    attr_reader :extension
    attr_reader :artist
    attr_reader :track
    
    # Checks if given file exists and if is supported,
    # in this case it sets instance attributes, if not
    # raises exception.
    
    def initialize(file_path)
      @path = file_path
      raise 'File not found or unreadable.' unless File.exists? @path and File.readable? @path
      @extension = File.extname(file_path)
      raise 'Not a valid audio file.' unless @extension == '.mp3'
      
      metadata = parse_metadata
      @artist = metadata['artist']
      @track = metadata['track']
    end
    
    # Returns the file metadata in a hash
    
    def parse_metadata
      bytes = get_last_bytes(128)
    end
    
    private
    
    # Returns the last n bytes of the file.
    # This bytes should correspond to the location
    # of the metadata info.
    
    def get_last_bytes(n)
      File.open(@path) do |f|
        f.seek(-n, IO::SEEK_END)
        f.read
      end
    end
  
  end
  
end