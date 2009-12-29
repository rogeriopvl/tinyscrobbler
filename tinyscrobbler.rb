require 'net/http'
require 'Digest/md5'

class BadFormatedResponseError < Exception; end
class BadTimeError < Exception; end
class RequestFailedError < Exception; end
class BannedError < Exception; end
class BadAuthError < Exception; end
class BadSessionError < Exception; end

class Lastfm_Scrobbler
  
  CLIENT_ID = 'tst'
  CLIENT_VERSION = '1.0'
  
  HANDSHAKE_BASE_URL = "http://post.audioscrobbler.com/?hs=true&p=1.2.1&c=#{CLIENT_ID}&v=#{CLIENT_VERSION}"
  
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
  
  def add(track)
    @queue.add(track)
  end
  
  def submit
    params = "s=#{@session_id}"
    i = 0
    @queue.each do |item|
      params << "&a[#{i}]=#{URI.escape(item['artist'])}"
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
  end
  
  def now_playing
    params = "s=#{@session_id}"
    params << "&a=#{URI.escape(artistname)}"
    params << "&t=#{URI.escape(track)}"
    params << "&b=#{URI.escape(album)}"
    params << "&l=#{URI.escape(secs)}"
    params << "&n=#{URI.escape(tracknumber)}"
    params << "&m=#{URI.escape(mbtrackid)}"
  end
  
  private #-----------------------------
  
  def handshake
    timestamp = Time.now.to_i.to_s
    token = generate_token(timestamp)
    
    begin
      url = URI.parse(HANDSHAKE_BASE_URL+"&u=#{@username}&t=#{timestamp}&a=#{token}")
      response = Net::HTTP.get(url)
    rescue Exception => e
      puts "Error on audioscrobbler handshake."
    end
    
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
  
  def generate_token(timestamp)
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(@password)+timestamp)
  end
  
  def send_submission(url, params)
    begin
      url = URI.parse(url)
      response = Net::HTTP.post(url, params)
    rescue Exception => e
      puts "Error on server request."
    end
    
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