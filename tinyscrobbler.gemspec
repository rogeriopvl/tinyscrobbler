Gem::Specification.new do |s|
  s.name = 'tinyscrobbler'
  s.version = '0.3.3'
  s.summary = "A very lightweight last.fm scrobbler library written in ruby."
  s.date = '2010-02-15'
  s.email = 'rogeriopvl@gmail.com'
  s.homepage = 'http://github.com/rogeriopvl/tinyscrobbler'
  s.has_rdoc = false
  s.add_dependency('ruby-mp3info', '>=0.6.13')
  s.authors = ["Rogério Vicente"]
  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Changelog
    example.rb
    lib/parser.rb
    lib/tinyscrobbler.rb
  ]
end
