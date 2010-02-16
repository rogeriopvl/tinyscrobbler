require 'rubygems'
require 'tinyscrobbler'

# this is just a quick and dirty way to avoid 
# placing the login credentials on version control :P
begin
  content = File.read('info.login').split("\n")
  username = content[0]
  password = content[1]
rescue Exception => e
  puts "Please create a file containing lastfm username and password in different lines."
end

begin
  ls = Tinyscrobbler::Client.new(username, password)
rescue Exception => e
  puts 'Error: unable to start last fm scrobbler.'
end

track_list = [
  {'artistname' => 'Khold', 'track' => 'Døde Fuglers Sang',
    'time' => '', 'source' => 'P', 'rating' => '',
    'secs' => '247', 'album' => 'Spiritual Black Dimensions', 'tracknumber' => '9', 'mbtrackid' => ''},
  {'artistname' => 'Emperor', 'track' => 'Depraved',
    'time' => '', 'source' => 'P', 'rating' => '',
    'secs' => '257', 'album' => 'Prometheus - The Discipline of Fire and Demise', 'tracknumber' => '2', 'mbtrackid' => ''}
]

parser = Tinyscrobbler::Parser.new("/Users/rogeriopvl/Music/iTunes/iTunes\ Music/Mão\ Morta/Primavera\ de\ Destroços/01\ Cão\ da\ Morte.mp3")

#track_list.each do |track|
#  track['time'] = Time.now.to_i.to_s
#  ls.now_playing(track)
#  sleep track['secs'].to_i/2
#  ls.played(track)
#end

ls.now_playing(parser.metadata)
sleep parser.metadata['secs'].to_i/2
ls.played(parser.metadata)