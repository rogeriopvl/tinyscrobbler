require '../tinyscrobbler'

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
  ls = Tinyscrobbler.new(username, password)
rescue Exception => e
  puts 'Error: unable to start last fm scrobbler.'
end

track_list = [
  {'artist' => 'Moonspell', 'track' => 'Vampiria',
    'time' => '1262185604', 'source' => 'P', 'rating' => '',
    'secs' => '347', 'album' => 'Wolfheart', 'tracknumber' => '6', 'mbtrackid' => ''},
  {'artist' => 'Emperor', 'track' => 'Empty',
    'time' => Time.now.to_i.to_s, 'source' => 'P', 'rating' => '',
    'secs' => '257', 'album' => 'Prometheus - The Discipline of Fire and Demise', 'tracknumber' => '3', 'mbtrackid' => ''}
]

# so now, it started playing Moonspell - "Alma Mater" (ftw)
current_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
  'album' => 'Wolfheart', 'secs' => '337', 'tracknumber' => '8', 'mbtrackid' => ''}


# now lets tell lastfm that we're headbanging like there's no tomorrow
#ls.now_playing(current_track)
track_list.each do |t|
  ls.played(t)
end
