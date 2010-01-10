require 'rubygems'
require 'mp3info'

module Audiometa
  
  # This class parses metadata from audio files.
  # It currently supports only mp3 files.
  
  class Parser
    
    # Checks if given file exists and if is supported,
    # and calls the parser method, if not
    # raises exception.
    
    def initialize(file_path)
      @path = file_path
      raise 'File not found or unreadable.' unless File.exists? @path and File.readable? @path
      @extension = File.extname(file_path)
      raise 'Not a valid audio file.' unless @extension == '.mp3'
      
      parse_metadata
    end
    
    private
    
    # Returns the file metadata in a hash
    
    def parse_metadata
      track = Mp3Info.new(@path)
      tag = track.hastag2? ? track.tag2 : track.tag1
      
      track_meta = {}
      track_meta['track'] = tag.title
      track_meta['artistname'] = tag.artist
      track_meta['album'] = tag.album
      track_meta['tracknumber'] = tag.tracknum.to_s
      track_meta['secs'] = track.length.round.to_s
      track_meta['time'] = Time.now.to_s
      track_meta['source'] = 'P'
      track_meta['mbtrackid'] = ''
      track_meta['rating'] = ''
      
      track_meta
    end
  
  end
  
end