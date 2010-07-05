require 'rubygems'
require '../lib/tinyscrobbler/auth.rb'
require '../lib/tinyscrobbler.rb'
require '../lib/parser.rb'

require 'test/unit'

class ClientTest < Test::Unit::TestCase
  
  def setup
    # this is just a quick and dirty way to avoid 
    # placing the login credentials on version control :P
    begin
      content = File.read('info.login').split("\n")
      @username = content[0]
      @password = content[1]
      @api_secret = content[2]
      @api_key = content[3]
      @skey = content[4]
    rescue Exception => e
      puts "Please create a file containing lastfm username, password, api_secret, api_key and session_key in different lines."
    end
    
    # lets make up a list of listened tracks
    @track_list = [
      {'artist' => 'Dimmu Borgir', 'track' => 'Arcane Lifeforce',
        'time' => '1262185646', 'source' => 'P', 'rating' => '',
        'secs' => '547', 'album' => 'Spiritual Black Dimensions', 'tracknumber' => '9', 'mbtrackid' => ''},
      {'artist' => 'Emperor', 'track' => 'Depraved',
        'time' => Time.now.to_i.to_s, 'source' => 'P', 'rating' => '',
        'secs' => '257', 'album' => 'Prometheus - The Discipline of Fire and Demise', 'tracknumber' => '2', 'mbtrackid' => ''}
    ]
    
    # lets make up the currently listening track
    @current_track = {'artistname' => 'Mão Morta', 'track' => 'Arrastando o seu cadáver',
      'album' => 'Primavera de Destroços', 'secs' => '337', 'tracknumber' => '8', 'mbtrackid' => ''}
  end
  
  # testing the connection with webauth
  def test_connect_with_webauth
    assert_nothing_raised do
      client = Tinyscrobbler::Client.new(:user => @username, :secret => @api_secret, :api_key => @api_key, :session_key => @skey)
    end
  end
  
  # testing the connection with username and password
  def test_connect_with_userpass
    assert_nothing_raised do
      client = Tinyscrobbler::Client.new(@username, @password)
    end
  end
  
  def test_now_playing_userpass
    client = Tinyscrobbler::Client.new(@username, @password)
    response = client.now_playing(@current_track)
  end
  
  def test_now_playing_webauth
    client = Tinyscrobbler::Client.new(:user => @username, :secret => @api_secret, :api_key => @api_key, :session_key => @skey)
    response = client.now_playing(@current_track)
    puts response.inspect
    exit
  end
  
  def test_played_userpass
    client = Tinyscrobbler::Client.new(@username, @password)
    @track_list.each do |t|
      client.played(t)
    end
  end
  
  def test_played_webauth
    client = Tinyscrobbler::Client.new(:user => @username, :secret => @api_secret, :api_key => @api_key, :session_key => @skey)
    @track_list.each do |t|
      client.played(t)
    end
  end
  
end