require 'bundler'
require "net/https"
require "uri"
require "lib/modernizr.rb"
Bundler::GemHelper.install_tasks

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

namespace :modernizr do
  desc "Download HEAD version of modernizer"
  task :download do
    # TODO: allow command line args to use a different point release
    uri = URI.parse("https://github.com/Modernizr/Modernizr/raw/master/modernizr.js")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    open(Rack::Modernizr::MODERNIZR_JS, "wb") do |file|
      file.write(response.body)
    end
  end
end
