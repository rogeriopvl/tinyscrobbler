require 'rake/clean'
require 'rubygems'

task :default => :package

$spec = eval(File.read('tinyscrobbler.gemspec'))

def package(ext='')
  "build/tinyscrobbler-#{$spec.version}" + ext
end

desc 'Run tests'
task :test do
  exec('ruby test/client_test.rb')
end

desc 'Build packages'
task :package => %w[.gem].map {|e| package(e)}

desc 'Build and install as local gem'
task :install => package('.gem') do
  sh "sudo gem install #{package('.gem')}"
end

directory 'build/'

file package('.gem') => %w[build/ tinyscrobbler.gemspec] + $spec.files do |f|
  sh "gem build tinyscrobbler.gemspec"
  mv File.basename(f.name), f.name
end
