# Tinyscrobbler

Tinyscrobbler is a lightweight LastFM track scrobbler library that allows to quickly incorporate the track scrobbling feature in a ruby player app.

I'm currently learning ruby, so it's very likely that this is not the best ruby code you've ever seen. But it works and I'll be optimizing it as I learn more about the language.

## Installation

To install Tinyscrobbler use rubygems:

	$ gem install tinyscrobbler

Depending on your system, you might need to use `sudo` to execute gem commands.

**Rubygems page:** [http://rubygems.org/gems/tinyscrobbler](http://rubygems.org/gems/tinyscrobbler)

## How to use

Some code example on how to use tinyscrobbler:

### Without parsing metadata

In this usage example you need to provide the track info (metadata), like artist name, album, song title etc. This is the recommended method, but you have to get the track info yourself.


	require 'rubygems'
	require 'tinyscrobbler'

	ls = Tinyscrobbler::Client.new(:user => "username", :secret => "API_SECRET", :api_key => "API_KEY", session_key => "SESSION_KEY")

	# Currently listening to...

	current_track = {'artistname' => 'Moonspell', 'track' => 'Alma Mater',
	  'time' => Time.now.to_s, 'source' => 'P', 'rating' => '',
	  'secs' => '337', 'album' => 'Wolfheart', 'tracknumber' => '8', 'mbtrackid' => ''}

	ls.now_playing(current_track)

	# after track played
	
	# you need to submit this only after
	# half of the track length has passed
	# or lastfm may ignore the submission
	
	ls.played(current_track)

### Parsing metadata

If you prefer to have tinyscrobbler parse the audio metadata for you, here's an example on how to do it.
Please notice that currently on mp3 files are supported (other formats are under development), this feature is the main reason why the "mp3info" gem is a dependency.

	require 'rubygems'
	require 'tinyscrobbler'
	
	ls = Tinyscrobbler::Client.new(lastfm_username, lasftfm_password)

	# Currently listening to...
	file_path = '/Users/rogeriopvl/Music/Moonspell/Wolfheart/08_Alma_Mater.mp3'
	current_track = Tinyscrobbler::Parser.new(file_path)
	
	ls.now_playing(current_track.metadata)
	
	# after track played
	
	# you need to submit this only after
	# half of the track length has passed
	# or lastfm may ignore the submission
	
	ls.played(current_track.metadata)
	

More info soon...
