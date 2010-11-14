# rack-modernizr

[Modernizr](http://modernizr.com) is a javascript utility that interrogates a user's web browser to determine its capabilities.  Unfortunately, all this delicious data is only available client-side.

rack-modernizr is a Rack Middleware that includes the Modernizr javascript and stuffs Modernizr's output into a cookie on the first page request.

# Installation

Include it in your application.rb like so:

    module ModernizrTestApp
      class Application < Rails::Application
        config.middleware.use Rack::Modernizr
      end
    end

or in your config.ru:

    # Initialize the rails application
    MyApp::Application.initialize!

    # This file is used by Rack-based servers to start the application.
    
    require ::File.expand_path('../config/environment',  __FILE__)
    require 'modernizr'

    # WARNING: session storage is not working properly with config.ru initialization :/
    use Rack::Modernizr
    
    run MyApp::Application

# Usage

In your rails code, Modernizr's client side detected browser functionality is now available from the Rack environment.  (w00t!)

    <%= request.env['X-rack-modernizr'].inspect %>

or

    if 1==request.env['X-rack-modernizr']['video']['h264']
      # do stuff
    end

# Features

Rack-modernizr chews up 1k of cookie data (yikes!).  If you are storing session data in the database or memcache, you can avoid the cookie tax by pushing modernizr data into the session:

    module ModernizrTestApp
      class Application < Rails::Application
        config.middleware.use Rack::Modernizr, :storage => "session"
      end
    end

# TODO

(in no particular order)
- Cool kid .accessorize method, like [rack-flash](http://nakajima.github.com/rack-flash/).
- Better unit testing for sessions and cookies.
- Rails helper to clean up retrieval syntax
- compression to cut down on 1k cookie storage size

# Thanks

rack-modernizr was inspired by [jamesgpearce](https://github.com/jamesgpearce)'s super awesome [modernizr-server](https://github.com/jamesgpearce/modernizr-server).  Some javascript was used from that project.

