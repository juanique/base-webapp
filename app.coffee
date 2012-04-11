express = require("express")
http = require("http")
fs = require("fs")
sys = require("sys")

app = express.createServer()

app.configure 'development', ->

app.error (err, req, res, next) ->
  sys.puts "APP.ERROR: " + sys.inspect(err)
  next err

publicDir = __dirname + "/public"
srcDir = __dirname + "/src"

app.use express.compiler(src: srcDir, dest: publicDir, enable: ["coffeescript", "less", "jade"])
app.use express.static(publicDir)
app.use express.bodyParser()

app.listen(3000)
