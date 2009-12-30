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

# so now, it started playing Moonspell - "Alma Mater" (ftw)
my_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
  'album' => 'Wolfheart', 'secs' => 337, 'tracknumber' => 8, 'mbtrackid' => ''}

# now lets tell lastfm that we're headbanging like there's no tomorrow
ls.now_playing(my_track)

