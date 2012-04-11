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

app.set "views", srcDir

app.use express.compiler(src: srcDir, dest: publicDir, enable: ["coffeescript", "less"])
app.use express.static(publicDir)
app.use express.bodyParser()

app.get /^\/$/, (req, res) ->
  res.render "index.jade", layout: false

app.get /.+\.html/, (req, res) ->
  jadeFile = req.originalUrl.replace(/html$/, "jade").substring(1)
  res.render jadeFile, layout: false

app.listen(3000)
