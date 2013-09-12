# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tinyscrobbler}
  s.version = "0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rogerio Vicente"]
  s.date = %q{2010-05-16}
  s.email = %q{rogeriopvl@gmail.com}
  s.files = ["Changelog", "LICENSE", "README.md", "example.rb", "lib/tinyscrobbler/parser.rb", "lib/tinyscrobbler.rb", "lib/tinyscrobbler/auth.rb", "test/gem_test.rb", "test/main_test.rb"]
  s.homepage = %q{http://github.com/rogeriopvl/tinyscrobbler}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A very lightweight last.fm scrobbler library written in ruby}

  s.add_dependency(%q<httparty>)
  s.add_dependency('ruby-mp3info', '>=0.6.13')
end
