# Tinyscrobbler is a lightweight library for scrobbling tracks
# to the LastFM submissions API.
# For more info on the submissions API visit:
# http://www.last.fm/api/submissions
# 
# Author:: Rogerio Vicente (http://rogeriopvl.com)
# Copyright:: Copyright (c) 2009 Rogerio Vicente
# License:: GPLv3

$: << File.expand_path(File.dirname(__FILE__))

require 'net/http'
require 'Digest/md5'
require 'tinyscrobbler/auth'

module Tinyscrobbler
  
  # Exception classes

  class BadFormatedResponseError < Exception; end
  class BadTimeError < Exception; end
  class RequestFailedError < Exception; end
  class BannedError < Exception; end
  class BadAuthError < Exception; end
  class BadSessionError < Exception; end

  # This is the lastfm submission api client class.
  # It contains necessary methods for full
  # interaction with LastFM submissions API.

  class Client

    CLIENT_ID = 'tny'
    CLIENT_VERSION = '0.3.3'

    HANDSHAKE_BASE_URL = "http://post.audioscrobbler.com/?hs=true&p=1.2.1&c=#{CLIENT_ID}&v=#{CLIENT_VERSION}"

    # Starts handshake and initializes instance attributes

    def initialize(username, password = nil)
      if username.is_a?(Hash)
        @username    = username[:user]
        @session_key = username[:session_key]
        @secret      = username[:secret]
        @api_key     = username[:api_key]

      else
        @username = username
        @password = password
      end

      @queue = []

      response = handshake()

      raise BadFormatedResponseError, 'Bad formated server response' if response.length != 4

      @session_id = response[1]
      @now_playing_url = response[2]
      @submission_url = response[3]
    end

    # Adds a new track to the queue
    # and submits the queue.
    # * artistname => the name of the artist
    # * track => the title of the track (song)
    # * album => the album name
    # * secs => the length of the track (seconds)
    # * tracknumber => the number of the track in album
    # * mbtrackid => the track's musicbrainz id
    # * time => the time the track started playing
    # * source => always 'P'
    # * rating => the track rating: L, B or S (love, ban, skip)

    def played(track)
      track["source"] ||= "P"

      @queue << track
      submit_queue
    end

    # Sends a now playing track.
    # track is a hash containing the following keys => values:
    # * artistname => the name of the artist
    # * track => the title of the track (song)
    # * album => the album name
    # * secs => the length of the track (seconds)
    # * tracknumber => the number of the track in album
    # * mbtrackid => the track's musicbrainz id

    def now_playing(track)
      params = "s=#{@session_id}"
      params << "&a=#{URI.escape(track['artistname'].to_s)}"
      params << "&t=#{URI.escape(track['track'].to_s)}"
      params << "&b=#{URI.escape(track['album'].to_s)}"
      params << "&l=#{URI.escape(track['secs'].to_s)}"
      params << "&n=#{URI.escape(track['tracknumber'].to_s)}"
      params << "&m=#{URI.escape(track['mbtrackid'].to_s)}"
      
      send_submission(@now_playing_url, params)
    end

    private

    def handshake_url
      timestamp = Time.now.to_i.to_s

      options = { "u" => @username, "t" => timestamp }

      if @password
        options["a"] = generate_token(timestamp)
      else
        options["a"]       = Tinyscrobbler::Auth::Web.authentication_token(@secret, timestamp)
        options["api_key"] = @api_key
        options["sk"]      = @session_key 
      end

      param_string = options.collect { |key, val| "#{key}=#{val}" }.join("&")

      "#{HANDSHAKE_BASE_URL}&#{param_string}"
    end

    # Executes the handshake with the API.
    # If handshake returned OK then the entire
    # response is returned in a array, where
    # * index 0 is the handshake result
    # * index 1 is the session id
    # * index 2 is the now playing url
    # * index 3 is the submissions url

    def handshake
      url = URI.parse(handshake_url)
      response = Net::HTTP.get(url)

      case response
      when /OK/
        response.split("\n")
      when /BADTIME/
        raise BadTimeError
      when /FAILED/
        raise RequestFailedError, response
      when /BANNED/
        raise BannedError
      when /BADAUTH/
        raise BadAuthError
      else
        raise RequestFailedError
      end
    end

    # Generates the handshake token.
    # This token is generated according to:
    # md5(md5(password)+timestamp)

    def generate_token(timestamp)
      Digest::MD5.hexdigest(Digest::MD5.hexdigest(@password)+timestamp)
    end

    # Prepares the POST data to submit the track queue.
    # After the submission the queue is emptied.

    def submit_queue
      params = "s=#{@session_id}"
      counter = 0
      @queue.each do |item|
        params << "&a[#{counter}]=#{URI.escape(item['artistname'].to_s)}"
        params << "&t[#{counter}]=#{URI.escape(item['track'].to_s)}"
        params << "&i[#{counter}]=#{URI.escape(item['time'].to_s)}"
        params << "&o[#{counter}]=#{URI.escape(item['source'].to_s)}"
        params << "&r[#{counter}]=#{URI.escape(item['rating'].to_s)}"
        params << "&l[#{counter}]=#{URI.escape(item['secs'].to_s)}"
        params << "&b[#{counter}]=#{URI.escape(item['album'].to_s)}"
        params << "&n[#{counter}]=#{URI.escape(item['tracknumber'].to_s)}"
        params << "&m[#{counter}]=#{URI.escape(item['mbtrackid'].to_s)}"
        counter+=1
      end

      send_submission(@submission_url, params)
      @queue = [] # clean it
    end

    # Submits the track queue POST data to the API.
    # If any error occurs it raises exception.

    def send_submission(url, params)

      url = URI.parse(url)
      http = Net::HTTP.new(url.host)
      response = http.post(url.path, params).body

      case response
      when /OK/
        # nice
      when /BADSESSION/
        raise BadSessionError
      else
        raise RequestFailedError, response
      end
      response
    end

  end
end
