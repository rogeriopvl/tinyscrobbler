require 'rubygems'
require 'tinyscrobbler.rb'

ls = Tinyscrobbler::Client.new(lastfm_username, lastfm_password)

# Currently listening to...

current_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
  'time' => '1262185646', 'source' => 'P', 'rating' => '',
  'secs' => '337', 'album' => 'Wolfheart', 'tracknumber' => '8', 'mbtrackid' => ''}

ls.now_playing(current_track)

# after track played

ls.played(current_track)


