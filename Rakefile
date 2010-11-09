require 'bundler'
Bundler::GemHelper.install_tasks

require "net/https"
require "uri"

require 'rake/rdoctask'
require 'rake/testtask'

desc "Run all the tests"
task :default => [:test]

desc "Run specs with test/unit style output"
task :test do
  sh "specrb -Ilib:test -w #{ENV['TEST'] || '-a'} #{ENV['TESTOPTS']}"
end

desc "Run specs with specdoc style output"
task :spec do
  sh "specrb -Ilib:test -s -w #{ENV['TEST'] || '-a'} #{ENV['TESTOPTS']}"
end

desc "Run all the tests"
task :fulltest do
  sh "specrb -Ilib:test -w #{ENV['TEST'] || '-a'} #{ENV['TESTOPTS']}"
end
