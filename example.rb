require 'rubygems'
require 'tinyscrobbler'

ls = Tinyscrobbler::Client.new(lastfm_username, lastfm_password)

# Currently listening to...

current_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
  'time' => Time.now.to_s, 'source' => 'P', 'rating' => '',
  'secs' => '337', 'album' => 'Wolfheart', 'tracknumber' => '8', 'mbtrackid' => ''}

# now playing notification
ls.now_playing(current_track)

# lastfm does not submit the track if
# half track length has not passed
sleep 170

# after track played, lets submit
ls.played(current_track)


