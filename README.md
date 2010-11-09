# rack-modernizr

[Modernizr](http://modernizr.com) is a javascript utility that interrogates a user's web browser to determine its capabilities.  Unfortunately, all this delicious data is only available client-side.

rack-modernizr is a Rack Middleware that includes the Modernizr javascript and stuffs Modernizr's output into a cookie on the first page request.

Include it in your config.ru like so:

    # This file is used by Rack-based servers to start the application.
    
    require ::File.expand_path('../config/environment',  __FILE__)
    require 'modernizr'
    use Rack::Modernizr
    
    run MyApp::Application

or environment.rb

    # Load the rails application
    require File.expand_path('../application', __FILE__)
    
    config.middleware.use Rack::Modernizr
    
    # Initialize the rails application
    MyApp::Application.initialize!

# TODO

Add usage section for retrieving cookie data in your application.  Test against multiple permutations of Rack/Ruby.

rack-modernizr was inspired by [jamesgpearce](https://github.com/jamesgpearce)'s super awesome [modernizr-server](https://github.com/jamesgpearce/modernizr-server).  Some javascript was used from that project.

