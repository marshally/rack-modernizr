module Rack
  class Modernizr
    def initialize(app, options = {})
      @app, @options = app, options
      @options[:modernizr_js_url] ||= "http://cachedcommons.org/cache/modernizr/1.5.0/javascripts/modernizr-min.js"
      @options[:cookie_name] ||= "Modernizr1"
    end

    def call(env)
      @req = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      
      puts headers.inspect
      if should_add_modernizr?(headers, response)
        response = add_modernizr(response)
        fix_content_length(headers, response)
      end
      # if !@req.cookies.has_key? "Modernizr"
      #   # body.gsub "</body", "Hello World</body"
      # end
      [status, headers, response]
    end

    def should_add_modernizr(headers, response)
      status==200 &&
        headers["Content-Type"] && 
        headers["Content-Type"].include?("text/html") && 
        response.respond_to?("body") && 
        !@req.cookies.has_key?( @options[:cookie_name] )
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
      [body.gsub /\<\/body\>/, "#{modernizr_js}</body>"]
    end
    
    def modernizr_js
      "<script src=\"#{@options[:modernizr_js_url]}\" type=\"text/javascript\"></script>" +
      "<script type=\"text/javascript\">#{set_cookie_js}</script>"
    end
    
    def set_cookie_js
        "var m=Modernizr,c='';" +
        "for(var f in m){" +
          "if(f[0]=='_'){continue;}" +
          "var t=typeof m[f];" +
          "if(t=='function'){continue;}" +
          "c+=(c?'|':'#{@options[:cookie_name]}=')+f+':';" +
          "if(t=='object'){" +
            "for(var s in m[f]){" +
              "c+='/'+s+':'+(m[f][s]?'1':'0');" +
            "}" +
          "}else{" +
            "c+=m[f]?'1':'0';" +
          "}" +
        "}" +
        "c+=';path=/';" +
        "try{" +
          "document.cookie=c;" +
        "}catch(e){}" +
      ""
    end
  end
end
