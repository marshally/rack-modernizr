require 'test/spec'
require 'rack/mock'
require 'rack-modernizr'

context "Rack::Modernizr" do

  context "when a modernizr cookie has not been set" do
    specify "should insert script tag" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.include? "script"
    end

    specify "should correct Content-Length header" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html', 'Content-Length' => 37}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      status, headers, body = Rack::Modernizr.new(app).call(request)
      
      body[0].length.should.not.equal test_body.length
      body[0].length.should.equal body[0].length
    end
    
    specify "should insert code when charset is specified" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html; charset=utf-8'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.include? "script"
    end

    specify "should insert correct URL if initialized" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html; charset=utf-8'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app, :modernizr_js_url => "http://distinctive.domain.com/modernizr.js").call(request).last
      body[0].should.include? "http://distinctive.domain.com/modernizr.js"
    end
    
    specify "should use cookie name if initialized" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html; charset=utf-8'}, [test_body]] }
      request = Rack::MockRequest.env_for("/rack-modernizr-endpoint.gif?a=b&c=d&e=f")
      status, headers, response = Rack::Modernizr.new(app, {:key_name => "distinctive_name", :storage => "cookie"}).call(request)
      headers['Set-Cookie'].should.not.be.nil
      headers['Set-Cookie'].should.include? "distinctive_name"
    end
    
    specify "should work if request body is fragmented" do
      test_body = ["<html><body>Hello World</bo", "dy></html>"]
      app = lambda { |env| [200, {'Content-Type' => 'text/html; charset=utf-8'}, test_body] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.include? "script"
    end
    
    specify "should not insert code if error response" do
      test_body = "<html><body>Not Found!</body></html>"
      app = lambda { |env| [404, {'Content-Type' => 'text/html'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.not.include? "script"
    end
    
    specify "should not insert code if non-html response" do
      test_body = "<html><body>Silly invalid html document that somehow gets stamped to text/css</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/css'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.css")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.not.include? "script"
    end
    
    specify "should not insert code if there is no body tag" do
      test_body = "<html>Malformed document</html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html")
      body = Rack::Modernizr.new(app).call(request).last
      body[0].should.not.include? "script"
    end
  end

  # cookie storage
  context "when a modernizr cookie has already been set" do
    specify "should not mess with the response in any way" do
      test_body = "<html><body>Hello World</body></html>"
      app = lambda { |env| [200, {'Content-Type' => 'text/html'}, [test_body]] }
      request = Rack::MockRequest.env_for("/test.html", "HTTP_COOKIE" => "Modernizr=a")
      status, headers, response = Rack::Modernizr.new(app, :storage => 'cookie').call(request)
      response[0].should.not.include? "script"
    end
  end
end