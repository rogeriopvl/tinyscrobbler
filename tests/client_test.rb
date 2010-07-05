require 'rubygems'
require 'test/unit'

require '../lib/tinyscrobbler.rb'
require '../lib/parser.rb'

class ClientTest < Test::Unit::TestCase
  
  def setup
    # this is just a quick and dirty way to avoid 
    # placing the login credentials on version control :P
    begin
      content = File.read('info.login').split("\n")
      @username = content[0]
      @password = content[1]
    rescue Exception => e
      puts "Please create a file containing lastfm username, password, api_secret, api_key and session_key in different lines."
    end
    
    # lets make up a list of listened tracks
    @track_list = [
      {'artist' => 'A Perfect Circle', 'track' => 'Judith',
        'time' => (Time.now.to_i - 1500).to_s, 'source' => 'P', 'rating' => '',
        'secs' => '547', 'album' => 'Mer de Noms', 'tracknumber' => '9', 'mbtrackid' => ''},
      {'artist' => 'More Than A Thousand', 'track' => 'The Virus',
        'time' => Time.now.to_i.to_s, 'source' => 'P', 'rating' => '',
        'secs' => '257', 'album' => 'The Hollow', 'tracknumber' => '10', 'mbtrackid' => ''}
    ]
    
    # lets make up the currently listening track
    @current_track = {'artistname' => 'Mão Morta', 'track' => 'Arrastando o seu cadáver',
      'album' => 'Primavera de Destroços', 'secs' => '337', 'tracknumber' => '8', 'mbtrackid' => ''}
      
      assert_nothing_raised do
        @client = Tinyscrobbler::Client.new(@username, @password)
      end
  end
  
  def test_played
    assert_nothing_raised do
      @track_list.each do |t|
        @client.played(t)
      end
    end
  end
  
  def test_now_playing
    assert_nothing_raised do
      @client.now_playing(@current_track)
    end
  end
  
end