Tinyscrobbler is a lightweight LastFM track scrobbler library that allows to quickly incorporate the track scrobbling feature in a ruby player app.

I'm currently learning ruby, so it's very likely that some code is not written the ruby way.

Tinyscrobbler is still under constant heavy changes but here's some early usage examples:

	require 'tinyscrobbler.rb'

	ls = Tinyscrobbler::Client.new(lastfm_username, lasftfm_password)

	# Currently listening to...

	current_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
	  'time' => '1262185646', 'source' => 'P', 'rating' => '',
	  'secs' => '337', 'album' => 'Wolfheart', 'tracknumber' => '8', 'mbtrackid' => ''}

	ls.now_playing(current_track)

	# after track played

	ls.played(current_track)

More info soon...
