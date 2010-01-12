require 'rubygems'
require 'mp3info'

module Tinyscrobbler
  
  # This class parses metadata from audio files.
  # It currently supports only mp3 files.
  
  class Parser
  
    attr_accessor :metadata
    
    # Checks if given file exists and if is supported,
    # and calls the parser method, if not
    # raises exception.
    
    def initialize(file_path)
      @path = file_path
      raise 'File not found or unreadable.' unless File.exists? @path and File.readable? @path
      @extension = File.extname(file_path).downcase
      raise 'Not a valid audio file.' unless @extension == '.mp3'
      
      @metadata = parse_metadata
    end
    
    private
    
    # Returns the file metadata in a hash
    
    def parse_metadata
      track = Mp3Info.new(@path)
      tag = track.hastag1? ? track.tag1 : track.tag2

      track_meta = {}
      track_meta['track'] = track.hastag1? ? tag.title : tag.TIT2
      track_meta['artistname'] = track.hastag1? ? tag.artist : tag.TPE1
      track_meta['album'] = track.hastag1? ? tag.album : tag.TALB
      track_meta['tracknumber'] = track.hastag1? ? tag.tracknum.to_s : tag.TRCK.to_s
      track_meta['secs'] = track.length.round.to_s
      track_meta['time'] = Time.now.to_s
      track_meta['source'] = 'P'
      track_meta['mbtrackid'] = ''
      track_meta['rating'] = ''
      
      track_meta
    end
  
  end
  
end