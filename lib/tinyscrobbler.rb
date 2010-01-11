# Tinyscrobbler is a lightweight library for scrobbling tracks
# to the LastFM submissions API.
# For more info on the submissions API visit:
# http://www.last.fm/api/submissions
# 
# Author:: Rogerio Vicente (http://rogeriopvl.com)
# Copyright:: Copyright (c) 2009 Rogerio Vicente
# License:: GPLv3

require 'net/http'
require 'Digest/md5'

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

    CLIENT_ID = 'tst'
    CLIENT_VERSION = '1.0'

    HANDSHAKE_BASE_URL = "http://post.audioscrobbler.com/?hs=true&p=1.2.1&c=#{CLIENT_ID}&v=#{CLIENT_VERSION}"

    # Starts handshake and initializes instance attributes

    def initialize(username, password)
      @username = username
      @password = password
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
      params << "&a=#{URI.escape(track['artistname'])}"
      params << "&t=#{URI.escape(track['track'])}"
      params << "&b=#{URI.escape(track['album'])}"
      params << "&l=#{URI.escape(track['secs'])}"
      params << "&n=#{URI.escape(track['tracknumber'])}"
      params << "&m=#{URI.escape(track['mbtrackid'])}"

      send_submission(@now_playing_url, params)
    end

    private

    # Executes the handshake with the API.
    # If handshake returned OK then the entire
    # response is returned in a array, where
    # * index 0 is the handshake result
    # * index 1 is the session id
    # * index 2 is the now playing url
    # * index 3 is the submissions url

    def handshake
      timestamp = Time.now.to_i.to_s
      token = generate_token(timestamp)

      url = URI.parse(HANDSHAKE_BASE_URL+"&u=#{@username}&t=#{timestamp}&a=#{token}")
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
      i = 0
      @queue.each do |item|
        params << "&a[#{i}]=#{URI.escape(item['artistname'])}"
        params << "&t[#{i}]=#{URI.escape(item['track'])}"
        params << "&i[#{i}]=#{URI.escape(item['time'])}"
        params << "&o[#{i}]=#{URI.escape(item['source'])}"
        params << "&r[#{i}]=#{URI.escape(item['rating'])}"
        params << "&l[#{i}]=#{URI.escape(item['secs'])}"
        params << "&b[#{i}]=#{URI.escape(item['album'])}"
        params << "&n[#{i}]=#{URI.escape(item['tracknumber'])}"
        params << "&m[#{i}]=#{URI.escape(item['mbtrackid'])}"
        i+=1
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
        puts response.inspect
        raise RequestFailedError, response
      end
      response
    end

  end
end