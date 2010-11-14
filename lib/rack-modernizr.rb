require 'rack'

module Rack
  class Modernizr
    attr_accessor :stash

    def initialize(app, options = {})
      @app, @options = app, options
      @options[:modernizr_js_url] ||= "http://cachedcommons.org/cache/modernizr/1.5.0/javascripts/modernizr-min.js"
      @options[:key_name] ||= "Modernizr"
      @options[:storage] ||= "cookie"
    end

    def call(env)
      @req = Rack::Request.new(env)

      load_modernizr_from_storage if have_modernizr?

      if env['PATH_INFO'] == "/rack-modernizr-endpoint.gif"
        return persist_modernizr
      end

      status, headers, response = @app.call(env)

      if should_add_modernizr?(status, headers, response)
        response = add_modernizr response 
        fix_content_length(headers, response)
      end


      [status, headers, response]
    end

    def have_modernizr?
      !storage[@options[:key_name]].nil?
    end

    def load_modernizr_from_storage
      puts "load_modernizr_from_storage"
      @req.env['X-rack-modernizr'] = Rack::Utils.parse_nested_query(storage[@options[:key_name]])
    end

    def should_add_modernizr?(status, headers, response)
      !storage.has_key?( @options[:key_name] ) &&
      status==200 &&
      headers["Content-Type"] && 
      headers["Content-Type"].include?("text/html")
    end

    def persist_modernizr
      response = Rack::Response.new ["OK"], 200, {}

      s = @req.env['QUERY_STRING']

      case @options[:storage]
      when "session"
        @req.env["rack.session"][@options[:key_name]] = s
      when "cookies"
      when "cookie"
        response.set_cookie(@options[:key_name], {:value => s, :path => "/"})
      end

      response.finish # finish writes out the response in the expected format.
    end

    def storage
      case @options[:storage]
      when "session"
        @req.env["rack.session"] ||= {}
        @req.env["rack.session"]
      when "cookies"
      when "cookie"
        @req.cookies ||= {}
        @req.cookies
      end
    end

    def fix_content_length(headers, response)
      # Set new Content-Length, if it was set before we mutated the response body
      if headers['Content-Length']
        length = response.to_ary.inject(0) { |len, part| len + bytesize(part) }
        headers['Content-Length'] = length.to_s
      end
    end

    def add_modernizr(response, body = "")
      response.each{ |s| body << s.to_s }
      [body.gsub(/\<\/body\>/, "#{modernizr_js}</body>")]
    end

    def modernizr_js
      "<div id='modernizr_img'></div><script src=\"#{@options[:modernizr_js_url]}\" type=\"text/javascript\"></script>" +
      "<script type='text/javascript'>#{set_modernizr_js}</script>"
    end

    def set_modernizr_js
      "var m=Modernizr,c='';" +
      "for(var f in m){" +
      "if(f[0]=='_'){continue;}" +
      "var t=typeof m[f];" +
      "if(t=='function'){continue;}" +
      "if(t=='object'){" +
      "for(var s in m[f]){" +
      "c+='&'+f+'['+s+']='+(m[f][s]?'1':'0');" +
      "}" +
      "}else{" +
      "c+='&'+f+'='+(m[f]?'1':'0');" +
      "}" +
      "}" +
      "document.getElementById('modernizr_img').innerHTML = \"<img src='/rack-modernizr-endpoint.gif?\"+c+\"'></img>\";"
    end
  end
end