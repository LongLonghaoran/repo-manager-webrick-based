# require 'webrick'
# require 'json'

# root = File.expand_path './'
# server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
# server.mount_proc '/repos/api/products/p1/repositories/r1' do |req, res|
#     res["content-type"] = "application/json"
#     res.body = {success: 'ok'}.to_json # your content here
# end
# trap 'INT' do server.shutdown end
# server.start

require 'byebug'
require 'rack'
require 'json'
require 'open3'
dir = File.expand_path 'uploads'
app = proc do |env|
    puts "request comming: ---------------------------------------------------------------------------"
    puts "#{Time.now}"
    req = Rack::Request.new(env)
    puts env
    file = req.params['file']
    full_path = req.fullpath
    File.open("#{dir}/#{file[:filename]}", 'w+') do |f|
        f.write file[:tempfile].read
    end
    stdout,stderr,status = ["", "", ""]
    # run sh
    case full_path
    when /repos\/api\/products\/V10/
        puts "executing ./deb-partner-v10.sh #{dir}/#{file[:filename]}:\n"
        stdout,stderr,status = Open3.capture3("./deb-partner-v10.sh #{dir}/#{file[:filename]}")
        puts "stdout:#{stdout}"
        puts "stderr:#{stderr}"
        puts "status:#{status}"
    when /repos\/api\/products\/V10-arm64/
        puts "pwd: \n" + `pwd`
        puts "executing ./deb-desktop-v10-arm64.sh #{dir}/#{file[:filename]}:\n"
        stdout,stderr,status = Open3.capture3("./deb-desktop-v10-arm64.sh #{dir}/#{file[:filename]}")
        puts "stdout:#{stdout}"
        puts "stderr:#{stderr}"
        puts "status:#{status}"
    else
        raise "wrong repo name"
    end
    raise stderr if stderr != ""

    [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
rescue => e
    [500, {"Content-Type" => "text/plain"}, [e.message]]
    # Rack::Response.new(nil, 200, [])
end

Rack::Server.start(
    app: app, Port: 3000
)